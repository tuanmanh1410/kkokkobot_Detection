# kkokkobot_Detection

This is repository for runing kkokkobot detection.
First, you need to install some packages or virtual environment

## Install
```
conda env create -f Egg_Detection.yml
```
After that, we need install pycocotools 2.0 for COCO dataset
```
conda install Cython
pip install pycocotools

```


## Dataset
First, we need run pre_process.py to make dataset with VOC format.
For example, here we have COLOR_5K_VOC dataset and structure is like this:
```
|__ COLOR_5K_VOC
|__ Convert2Coco.sh
|__ Egg_Detection.yml
|__ Inference.sh
|__ pre_process.py
|__ README.md
|__ RunALL.sh
|__ Train.sh
```
Change execute permission for Convert2Coco.sh and RunALL.sh ...
```
chmod +x Convert2Coco.sh
chmod +x RunALL.sh
chmod +x Train.sh
chmod +x Inference.sh
```

Then, we can run step by step:
``` 
./Convert2Coco.sh
./Train.sh
./Inference.sh
``` 
Or run all in one time:
```
./RunALL.sh
```

Note that inside Train.sh already contains Inference phase, so you can run Train.sh only one time to get result.

We need to modify some parameters in scripts files to run with your own dataset fitting with flexible case as well as hardware.
