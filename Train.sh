#!/bin/bash
# Make shell script for training Custom Dataset

COCO_dir = $1
COCO="../$COCO_dir"
NUM_CLASSES=$2
NUM_EPOCHS=$3
BATCH_SIZE=$4
NUM_GPU=$5
OUTPUT=$6

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

python Get_checkpoint.py

python -m torch.distributed.launch --nproc_per_node=$NUM_GPU --use_env main.py --coco_path $COCO --resume ./detr-r50_no-class-head.pth \
--batch_size $BATCH_SIZE --num_classes $NUM_CLASSES --output_dir $OUTPUT --epochs $NUM_EPOCHS

python final_evaluate.py --coco_path $COCO --batch_size $BATCH_SIZE --num_classes $NUM_CLASSES --resume $OUTPUT/best.pth --detail True

# Move to main folder
cd ..