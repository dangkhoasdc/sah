Introduction
============
This is `sah`, the hashing framework which simultaneously learn embedding image representation and hashing code. It also implements `relaxed-ba`, an improved of [Binary Autoencoder](https://arxiv.org/abs/1501.00756). We also provide pre-trained hashing model for following datasets:

- [Oxford5k](http://www.robots.ox.ac.uk/~vgg/data/oxbuildings/).
- [Holidays](http://lear.inrialpes.fr/~jegou/data.php)

Citation
=========

The work will be presented in CVPR 2017.

If you use the code in your paper, then please cite it as:

```
@article{do2017simultaneous,
  title={Simultaneous Feature Aggregating and Hashing for Large-scale Image Search},
  author={Do, Thanh-Toan and Tan, Dang-Khoa Le and Pham, Trung T and Cheung, Ngai-Man},
  journal={arXiv preprint arXiv:1704.00860},
  year={2017}
}
```

Requirement & Data
===========
The code requires Matlab version 2014 or higher.

## Data
All training data in the code are extracted from conv5 layer in the network [VGG-16](http://www.robots.ox.ac.uk/~vgg/research/very_deep/). All data should be put into the `data` folder. The models have to be put on `workdir`.
We provide following data for training/testing:

- Training data/ Dataset/ Query and groundtruth of Oxford5k
    - [`paris6k_conv5_vgg16`](https://www.dropbox.com/s/vaw1s64rlamr0t8/paris6k_conv5_vgg16.mat?dl=0)
    - [`oxford5k_conv5_vgg16`](https://www.dropbox.com/s/4d5yth1upo7x4tp/oxford5k_conv5_vgg16.mat?dl=0)
    - [`oxfordq_conv5_vgg16`](https://www.dropbox.com/s/v45rn2wzrimjcp6/oxfordq_conv5_vgg16.mat?dl=0)
    - [groundtruth](https://www.dropbox.com/s/xwdykr99r2ughhv/gnd_oxford5k.mat?dl=0)
- Training data/ Dataset/ Query and groundtruth of Holidays
    - [`flickr10k_conv5_vgg16`](https://www.dropbox.com/s/z7ddk4qrq8ldycd/flickr10k_conv5_vgg16.mat?dl=0)
    - [`holidays_conv5_vgg16`](https://www.dropbox.com/s/3xhl9e5t2fas8j1/holidays_conv5_vgg16.mat?dl=0)
    - [`holidaysq_conv5_vgg16`](https://www.dropbox.com/s/yd25u882qylilg7/holidaysq_conv5_vgg16.mat?dl=0)
    - [groundtruth](https://www.dropbox.com/s/dce8yt676zwdyxe/gnd_holidays.mat?dl=0)

The pre-trained models are provided as the following format:

```
sah_{dataset-name}_c{code-length}
```

Test a model
============

In `test_retrieval.m`, please change `dataset` to `holidays/oxford5k` to test on Holidays and Oxford5k , respectively. You also need to change `code_length` to `8/16/24/32` in order to achieve the result as which are reported in the paper. By default, please put datasets on the `data` folder and pre-trained `sah` models into the `workdir` folder. Finally, run `test_retrieval`.

The table shows the mAP results in Oxford5k and Holidays datasets:

| Dataset       | 8     | 16     | 24    | 32    |
| ------------- |:-----:| :-----:|:-----:|:-----:|
| Oxford5k      | 8.44  | 12.70  | 14.05 | 18.05 |
| Holidays      | 7.52  | 21.15  | 33.02 | 39.18 |


Training models
===========

The training function is implemented on `train.m`. Similar to `test_retrieval`, please change the dataset name and code length in `dataset` and `code_length`, respectively. To finetune parameters, you can consider these following variables:

- lambda.
- beta.
- gamma.
- mu

For more detail, please check the paper. After training, the model is saved in the `workdir` folder as the format I have mentioned before. Please noting that the model is only saved when it achieves higher result than `max_map`.

