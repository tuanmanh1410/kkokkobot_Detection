#!/bin/bash
# Make shell script for training Custom Dataset

COCO="../COLOR_5K_COCO" # Path to Dataset following COCO format
NUM_CLASSES=7 # Number of classes in your dataset
NUM_EPOCHS=100
BATCH_SIZE=2
NUM_GPU=4
OUTPUT="outputs_color"

# Check if main folder already exists
if [ ! -d ./detr_Egg_Detection ]; then
  # Create the new folder
  git clone https://github.com/tuanmanh1410/detr_Egg_Detection.git
  cd ./detr_Egg_Detection

  # Print message to confirm the folder was created
  echo "Successfully cloned detr_Egg_Detection"
else
  # Print message if folder already exists
  echo "Folder detr_Egg_Detection already exists"
  cd ./detr_Egg_Detection
fi

# Firstly, we need to download the pretrained model with no class head for preparing training own dataset
python Get_checkpoint.py

# Train the model
# --nproc_per_node: Number of GPUs
# --use_env: Use environment variables to pass arguments
# --coco_path: Path to Dataset following COCO format
# --resume: Path to pretrained model
# --batch_size: Batch size
# --num_classes: Number of classes in your dataset
# --output_dir: Path to save the model
# --epochs: Number of epochs
python -m torch.distributed.launch --nproc_per_node=$NUM_GPU --use_env main.py --coco_path $COCO --resume ./detr-r50_no-class-head.pth \
--batch_size $BATCH_SIZE --num_classes $NUM_CLASSES --output_dir $OUTPUT --epochs $NUM_EPOCHS

# Evaluate the model after training
# --coco_path: Path to Dataset following COCO format
# --batch_size: Batch size
# --num_classes: Number of classes in your dataset
# --resume: Path to pretrained model
# --detail: Show the detail of evaluation of bbox
python final_evaluate.py --coco_path $COCO --batch_size $BATCH_SIZE --num_classes $NUM_CLASSES --resume $OUTPUT/best.pth --detail True

# Move to main folder
cd ..