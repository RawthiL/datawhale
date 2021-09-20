# Deep Learning Jupyter design environment 

This docker is intended to be used as a design/test environment for deep learning projects. It is image/graphics/text oriented but it also contains many other libraries that I find useful. The highlights are:

### General stuff
- **TensorFlow 2.5** : Backbone for DL with tensorflow-hub for transfer learning.
- **Keras** : For coding, including keras-tuner package for hyper-parameter tunning.
- **Scikit** : Always useful.
- **pandas** : Essential for data handling (and uninstalling Excel).
- **pydot** and **scikit-multilearn** : Useful for multi-label problems and graph analysis. The pydot plot function is working with *cairo*.
- **BeautifulSoup4** : Along with **html5lib** for data extraction.

### Image stuff
- **OpenCV** : Essential for image processing.
- **imgaug** : For image augmentation.
- **pyntcloud** : For point cloud analysis.
- **pytesseract** : A great OCR by Google. The image includes the python wrapper and the tesseract binary.

### Text stuff
- **nltk** : Natural language processing toolkit.
- **textblob** : Other language procesing tool.

## Pipeline support

The image is built with pipeline development support. As of writing this text TFX 1.0 is not flexible enough for me (see commits), so I decided to use a more versatile solution, Airflow alone (and a lot of custom code...). Thus, this image contains support for using such pipelines with:

- **apache-airflow** [2.1.1]: Pipeline...
- **certifi** [2019.11.28]
- **Flask**[1.1.4]
- **SQLAlchemy**[1.3.24]
- **redis**[3.5.3]
- **tensorflow-serving-api** [2.5.1]: For serving the models in production.


## Other characteristics of the system:

- Ubuntu 20.04
- CUDA 11.2.2
- CUDNN 8.1.1
- Python 3.8.10

# Usage

### Build

`docker build -t datawhale:tf-2.5 .`

### Single Jupyter service

`docker run -u $UID:$UID --gpus all -v <path to code folder>:/home/datawhale/code -v <path to datasets folder (optional)>:/home/datawhale/datasets -p 8888:8888 -p 6006:6006 -it datawhale:tf-2.5`

### Full pipeline service

The first time run:

`docker-compose up --build create_user`

This will create a user for you, with credentials `airflow:airflow`. When this is done, all you need to do is call:

`docker-compose up --build`

Happy codding!
