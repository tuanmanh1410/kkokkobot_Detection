#!/bin/bash
# Make shell script for converting VOC to COCO format

# Usage: ./Convert2CoCo.sh <VOC_dir> <COCO_dir> <label_file_name>
# e.g., ./Convert2CoCo.sh ./voc_data/COLOR ./coco_data/COLOR label_color.txt
# Make new dicrectory for COCO format

# 3 below folders need to be modified to fit your own path
VOC=$1
COCO=$2
label=$3

# Check if folder already exists
if [ ! -d $COCO ]; then
  # Create the new folder
  mkdir $COCO

  # Print message to confirm the folder was created
  echo "Successfully created $COCO"
else
  # Print message if folder already exists
  echo "Folder $COCO already exists"
fi

# Make sub folder inside COCO : <COCO_dir>/annotations
anotation="annotations"

# Check if folder already exists
if [ ! -d $COCO/$anotation ]; then
  # Create the new folder
  mkdir $COCO/$anotation

  # Print message to confirm the folder was created
  echo "Successfully created $COCO/$anotation"
else
  # Print message if folder already exists
  echo "Folder $COCO/$anotation already exists"
fi


train="train"
val="val"
test="test"


# Copy all files from VOC to COCO
cp -r $VOC/$train $COCO
cp -r $VOC/$val $COCO
cp -r $VOC/$test $COCO

# Check if folder already exists
if [ ! -d ./voc2coco ]; then
  # Create the new folder
  git clone https://github.com/tuanmanh1410/voc2coco.git
  cd ./voc2coco

  # Print message to confirm the folder was created
  echo "Successfully cloned voc2coco"
else
  # Print message if folder already exists
  echo "Folder voc2coco already exists"
  cd ./voc2coco
fi

# Make empty file path first 
> train_path.txt
> val_path.txt
> test_path.txt

# Get file path
python Get_FilePath.py $VOC/$train xml ./train_path.txt
python Get_FilePath.py $VOC/$val xml ./val_path.txt
python Get_FilePath.py $VOC/$test xml ./test_path.txt

# Convert VOC to COCO
python voc2coco.py --ann_paths_list ./train_path.txt --labels $label --output $COCO/$anotation/train.json
python voc2coco.py --ann_paths_list ./val_path.txt --labels $label --output $COCO/$anotation/val.json
python voc2coco.py --ann_paths_list ./test_path.txt --labels $label --output $COCO/$anotation/test.json

# Remove xml file in COCO path except for test folder
python remove_files.py $COCO/$train xml
python remove_files.py $COCO/$val xml
#python remove_files.py $COCO/$test xml

# Move to main folder
cd ..

