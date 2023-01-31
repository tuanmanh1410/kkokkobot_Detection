import os
import csv
import argparse
from PIL import Image

parser = argparse.ArgumentParser(description='KKoKKo-BOT detection dataset pre-processing')
parser.add_argument('--root-dir', dest='root_dir', default='./data', help='Pass the path information of the original detection dataset', type=str)
parser.add_argument('--tgt-dir', dest='tgt_dir', default='./voc_data', help='Pass the target path where to store the processing results', type=str)
parser.add_argument('--train-ratio', dest='train_ratio', default=0.8, type=float)

def construct_DetectionDataset(root_dir, tgt_dir, train_ratio):
    """
    Find pair name.jpg and name.xml in the sub folders in root_dir
    And then copy them to tgt_dir
    :param root_dir: root directory of dataset
    :param tgt_dir: target directory of dataset
    :param train_ratio: ratio of train/test set 
    :return:
    """
    os.makedirs(tgt_dir + '/train', exist_ok = True)
    os.makedirs(tgt_dir + '/test', exist_ok = True)
    os.makedirs(tgt_dir + '/val', exist_ok = True)
    if len(os.listdir(tgt_dir + '/train')) != 0:
        print('[*] Training/Test Detection dataset is already constructed !!')
        return
    else:
        print('[*] Start to construct Training/Test dataset ...')

    ######################################################
    # create dataset (split train/test dataset & root_dir)
    ######################################################
    f_tr = open(tgt_dir + '/train_labels.csv', 'w+', newline='')
    f_val = open(tgt_dir + '/val_labels.csv', 'w+', newline='')
    f_ts = open(tgt_dir + '/test_labels.csv', 'w+', newline='')

    wr_tr = csv.writer(f_tr)
    wr_val = csv.writer(f_val)
    wr_ts = csv.writer(f_ts)

    count =  0 # variable for counting number for spliting purpose
    threshold = train_ratio * 10 # threshold for spliting purpose

    # Get all directories in root_dir
    sub_folders = [x[0] for x in os.walk(os.path.abspath(root_dir))]
    for sub in (sub_folders):
        img_list = os.listdir(sub)
        for i, img_name in enumerate(img_list):
            # Check existence of pair image and xml files
            #if (count == 5000):
            # break
            if (img_name[-3:] == 'jpg') and (os.path.exists(sub + '/' + img_name[:-3] + 'xml')):
                # Copy image to target dir (instead of simple copy, we open and convert to RGB)
                if (count % 10 < threshold):
                    dir_path = tgt_dir + '/train'
                    wr = wr_tr
                elif (count % 10 == threshold):
                    dir_path = tgt_dir + '/val'
                    wr = wr_val
                else:
                    dir_path = tgt_dir + '/test'
                    wr = wr_ts

                print(f'[{count}][{dir_path}] {img_name}')
                
                image = Image.open(sub + '/' + img_name).convert("RGB")
                image.save(dir_path + '/' + img_name)

                # Copy xml to target dir
                os.system('cp ' + sub + '/' + img_name[:-3] + 'xml ' + dir_path + '/' + img_name[:-3] + 'xml')

                # Alternative way to copy xml file (Read and wirte to dir_path using python library)

                # Add label to .csv file
                wr.writerow([img_name, sub])

                count += 1

    f_tr.close()
    f_val.close()
    f_ts.close()
    print('The total images:', count)


# Main function
if __name__ == '__main__':

   args = parser.parse_args()
   construct_DetectionDataset(root_dir =args.root_dir, tgt_dir=args.tgt_dir, train_ratio=args.train_ratio)


