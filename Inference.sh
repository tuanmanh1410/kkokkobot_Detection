#!/bin/bash
# Make shell script for training Custom Dataset

COCO="../COLOR_5K_COCO"
NUM_CLASSES=7
BATCH_SIZE=2
OUTPUT="outputs_color"
CHECK_POINT="best.pth"

cd ./detr_Egg_Detection
python final_evaluate.py --coco_path $COCO --batch_size $BATCH_SIZE --num_classes $NUM_CLASSES --resume $OUTPUT/$CHECK_POINT --detail True

# Move to main folder
cd ..
