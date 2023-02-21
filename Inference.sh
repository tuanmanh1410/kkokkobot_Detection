#!/bin/bash
# Make shell script for training Custom Dataset

COCO=$1
NUM_CLASSES=$2
BATCH_SIZE=$3
CHECK_POINT=$4

cd ./detr_Egg_Detection
python final_evaluate.py --coco_path $COCO --batch_size $BATCH_SIZE --num_classes $NUM_CLASSES --resume $CHECK_POINT --detail True

# Move to main folder
cd ..
