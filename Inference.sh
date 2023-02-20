#!/bin/bash
# Make shell script for training Custom Dataset

COCO_dir = $1
COCO="../$COCO_dir"
NUM_CLASSES=$2
BATCH_SIZE=$3
OUTPUT=$4
CHECK_POINT=$5

cd ./detr_Egg_Detection
python final_evaluate.py --coco_path $COCO --batch_size $BATCH_SIZE --num_classes $NUM_CLASSES --resume $OUTPUT/$CHECK_POINT --detail True

# Move to main folder
cd ..
