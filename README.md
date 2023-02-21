# kkokkobot_Detection

본 문서는 `Ubuntu18:04` 에서  `계란 상태 자동 탐지 데이터` 의 활용 예시인 DETR 모델의 학습 및 추론을 실행시킬 수 있는 환경 구축 가이드입니다. 

# 설치 가이드

## 로컬환경에서 설치하기

### Anaconda 설치하기

### 1. `Anaconda` 설치하기

```bash
$ wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh 
$ bash Anaconda3-2022.10-Linux-x86_64.sh 
```

### 2. `Anaconda` 를 사용한 가성환경 생성

본 repository에 있는 environment.yaml은 학습에 필요한 python package 정보들을 포함하고있습니다.
아래의 명령어를 사용하여, 자신의 로컬 환경에서 모델을 본 모델을 학습/추론 할 수 있는 환경을 구축할 수 있습니다.

```bash
$ conda env create -f Egg_Detection.yml
```

```bash
$ conda activate kkokkobot
```

### 3. pycocotools 2.0 설치하기

```bash
$ conda install Cython
$ pip install pycocotools
```

# 데이터 셋 준비하기

먼저, 우리는 DETR 학습에 사용가능하도록 제공한 데이터를 VOC 포맷을으로 바꿔주어야합니다. 이를 우리는 `pre_process.py` 라는 전처리 코드를 제공합니다.  전처리 코드는 실행 시 `--root-dir` 정보, `--tgt-dir` 정보, `--train-ratio` 정보를 인자로 넘겨주도록 되어있습니다. 

- `--root-dir` : 제공된 학습 데이터 경로
- `--tgt-dir` : 학습용으로 변환된 데이터가 저장될 경로
- `--train-ratio` : 학습 비율 (예, 0.8인경우 train : val : test = 8 : 1 : 1)

```bash
$ python pre_process.py --root-dir './data/COLOR' --tgt-dir './voc_data/COLOR' --train-ratio 0.8

[1][./voc_data/COLOR/train] 20220921-03026.jpg
[2][./voc_data/COLOR/train] 20220921-02944.jpg
...
[1339][./voc_data/COLOR/test] 20220921-02805
```

위의 `pre_process.py` 명령어 실행은 다음과 같이 VOC 형태로 변환된 데이터가 저장되며 train / val / test 폴더 내에 지정한 비율을 맞추어 구축됩니다.

```bash
kkokkobot/
|_data/
|		|_ COLOR
|		|_ MONO
|_voc_data
|		|_ COLOR
|		     |_ train
|		     |_ train_labels.csv
|		     |_ val
|		     |_ val_labels.csv
|		     |_ test
|		     |_ test_labels.csv
|_Convert2Coco.sh
|_ Egg_Detection.yml
|_ Inference.sh
|_ pre_process.py
|_ README.md
|_ RunALL.sh
|_ Train.sh
```

# 학습 및 추론

간편한 모델 학습 및 추론을 위해 쉘스크립트를 사용한 학습 및 추론을 지원합니다. 쉘 스크립트는 구축한 DETR 모델을 git repository인 https://github.com/tuanmanh1410/detr_Egg_Detection.git 로부터 가져와서 자동으로 실행하는 역할을합니다. 학습 및 추론에 사용할 파라미터는 쉘스크립트 편집을 통해 수행할 수 있습니다.

### (공통 필수) Script 권한 바꾸기

```bash
$ chmod +x Convert2Coco.sh
$ chmod +x RunALL.sh
$ chmod +x Train.sh
$ chmod +x Inference.sh
```

---

### (선택 1) Script를 사용하여 한번에 데이터 셋 변환, 학습, 추론 수행하기

- `[RunALL.sh](http://RunALL.sh)` 는 데이터 변환에서부터 학습 및 추론을 모두 수행하는 쉘스크립트입니다. 다음의 인자 전달을 통해 변환에서부터 학습, 추론까지 모두 실행할 수 있습니다.

```bash
$ ./RunAll.sh <VoC_dir> <COCO_dir> <label_file_name> <num_classes> <num_epochs> <batch_size> <num_gpus> <output> <check_point_name>
```

 예를 들어, `./RunAll.sh COLOR_5K_VOC COLOR_5K_COO label_color.txt 7 2 2 4 outputs_color best.pth`    와 같이 실행시킬 수 있습니다.

---

### (선택 2) 개별 스크립트 수행

**Step 1. Script를 사용한 데이터 셋 변환**

DETR 모델은 VOC 형태가 아닌 COCO 포맷을 사용합니다. 따라서, VOC 형태를 다시 COCO 형태로 변환해주어야합니다. 이 파일은 자동화 스크립트를 통해서 쉽게 수행할 수 있습니다.

```xml
$ Convert2Coco.sh <VOC_dir> <COCO_dir> <label_file_name>
```

예를 들어, `./Convert2CoCo.sh voc_data/COLOR ./coco_data/COLOR label_color.txt` 을 수행하면 다음과 같이 COCO 포맷의 데이터 셋이 구축됩니다.

```xml
kkokkobot/
|_data/
|		|_ COLOR
|		|_ MONO
|_voc_data
|		|_ COLOR
|		     |_ train
|		     |_ train_labels.csv
|		     |_ val
|		     |_ val_labels.csv
|		     |_ test
|		     |_ test_labels.csv
|_coco_data
|		|_ COLOR
|		     |_ train/
|		     |_ val/
|		     |_ test/
|		     |_ annotations/
|_Convert2Coco.sh
|_ Egg_Detection.yml
|_ Inference.sh
|_ pre_process.py
|_ README.md
|_ RunALL.sh
|_ Train.sh
```

- **Step 2. Script를 사용한 DETR 학습**

```bash
$ ./Train.sh <COCO_dir> <Num_Classes> <Num_Epochs> <Batch_Size> <Num_GPU> <Output>
```

- **Step 3. Script를 사용한 DETR 결과 추론**

```bash
$ ./Inference.sh <COCO_dir> <Num_Classes> <Batch_Size> <Check_point_path>
```
