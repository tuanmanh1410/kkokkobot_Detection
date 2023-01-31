#!/bin/bash
# Make shell script for training Custom Dataset
# Run Inference.sh to evaluate the model after training finish

COCO="../COLOR_5K_COCO"
NUM_CLASSES=7
BATCH_SIZE=2
OUTPUT="outputs_color"
CHECK_POINT="best.pth"

cd ./detr_Egg_Detection
# Evaluate the model after training
# --coco_path: Path to Dataset following COCO format
# --batch_size: Batch size
# --num_classes: Number of classes in your dataset
# --resume: Path to pretrained model (best.pth)
# --detail: Show the detail of evaluation of bbox

python final_evaluate.py --coco_path $COCO --batch_size $BATCH_SIZE --num_classes $NUM_CLASSES --resume $OUTPUT/$CHECK_POINT --detail True

# Move to main folder
cd ..
