#!/bin/bash
# Make shell script for training Custom Dataset

COCO="../COLOR_5K_COCO"
NUM_CLASSES=7
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
  echo "Successfully cloned voc2coco"
else
  # Print message if folder already exists
  echo "Folder DETR already exists"
  cd ./detr_Egg_Detection
fi

python Get_checkpoint.py

python -m torch.distributed.launch --nproc_per_node=$NUM_GPU --use_env main.py --coco_path $COCO --resume ./detr-r50_no-class-head.pth \
--batch_size $BATCH_SIZE --num_classes $NUM_CLASSES --output_dir $OUTPUT --epochs $NUM_EPOCHS

python final_evaluate.py --coco_path $COCO --batch_size $BATCH_SIZE --num_classes $NUM_CLASSES --resume $OUTPUT/best.pth --detail True

# Move to main folder
cd ..