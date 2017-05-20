Introduction
============
This is `sah`, the hashing framework which simultaneously learn embedding image representation and hashing code. It also implements `relaxed-ba`, an improved of Binary Autoencoder. We also provide pre-trained hashing model for following datasets:

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
All training data in the code are extracted from conv5 layer in the network VGG-16. All data should be put into folder `data`. The models have to be put on `workdir`.
We provide following data for training/testing:

- Training data/ Dataset/ Query and groundtruth of Oxford5k
    - `paris6k_conv5_vgg16`
    - `oxford5k_conv5_vgg16`
    - `oxfordq_conv5_vgg16`
    - groundtruth
- Training data/ Dataset/ Query and groundtruth of Holidays
    - `flickr10k_conv5_vgg16`
    - `holidays_conv5_vgg16`
    - `holidaysq_conv5_vgg16`
    - groundtruth

The pre-trained models are provided as the following format:


```
sah_{dataset-name}_c{code-length}
```

Test a model
============

In `test_retrieval.m`, please change `dataset` to `holidays/oxford5k` to test on Holidays and Oxford5k dataset, respectively. You also need to change `code_length` to `8/16/24/32` in order to achieve the result as which are reported in the paper.By default, please put datasets on `data` folder and pre-trained `sah` models into `workdir` folder. Finally, run `test_retrieval`.


Cause the pre-trained models are updated after paper submission. Here is the new results:


| Dataset       | 8     | 16     | 24    | 32    |
| ------------- |:-----:| :-----:|:-----:|:-----:|
| Oxford5k      | 8.44  | 12.70  | 14.05 | 18.05 |
| Holidays      | 7.52  | 21.15  | 33.02 | 39.18 |


Training models
===========

Similar to `test_retrieval`, please change the dataset name and code length in `dataset` and `code_length`, respectively. To finetune parameters, you can consider these following values:

- lambda.
- beta.
- gamma.
- mu

For more detail, please check the paper. After training, the model is saved in `workdir` folder as the format I have mentioned before. Please noting that the model is only saved when it achieves higher result than `max_map`.

