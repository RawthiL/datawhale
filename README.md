# Deep Learning Jupyter design environment

This docker is intended to be used as a design/test environment for deep learning projects. It is image/graphics oriented but it also contains many other libraries that I find useful. The highlights are:

- **TensorFlow 2.4** : Backbone for DL with tensorflow-hub for transfer learning.
- **Keras** : For coding, including keras-tuner package for hyper-parameter tunning.
- **Scikit** : Always useful.
- **OpenCV** : Essential for image processing.
- **pyntcloud** : For point cloud analysis.
- **pandas** : Essential for data handling (and uninstalling Excel).
- **pydot** and **scikit-multilearn** : Useful for multi-label problems and graph analysis. The pydot plot function is working with *cairo*.
- **BeautifulSoup4** : Along with **html5lib** for data extraction.

Other characteristics of the system:

- Ubuntu 20.04
- CUDA 11.0.3
- CUDNN 8.0.4.30-1
- Python 3.7.4
- LIBNVINFER 7.1.3


Happy codding!
