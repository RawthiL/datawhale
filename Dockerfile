ARG UBUNTU_VERSION=18.04
ARG CUDA=10.1

FROM nvidia/cuda:${CUDA}-base-ubuntu${UBUNTU_VERSION}
ARG CUDA

ENV CUDNN=7.6.5.32-1
ARG CUDNN_MAJOR_VERSION=7
ARG LIB_DIR_PREFIX=x86_64
ARG LIBNVINFER=6.0.1-1
ARG LIBNVINFER_MAJOR_VERSION=6

ENV HOME /home/datawhale
ENV PYTHON_VERSION 3.7.4
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive


SHELL ["/bin/bash", "-c"]

RUN useradd -ms /bin/bash datawhale
RUN su datawhale

RUN apt-get update   \
    && apt-get upgrade -y   \
    && apt-get install -y --no-install-recommends apt-utils   

RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated  \
    build-essential  \
    ca-certificates  \
    cuda-command-line-tools-${CUDA/./-}  \
    libcublas10=10.2.1.243-1  \
    cuda-cudart-${CUDA/./-}  \
    cuda-nvrtc-${CUDA/./-}  \
    cuda-cufft-${CUDA/./-}  \
    cuda-curand-${CUDA/./-}  \
    cuda-cusolver-${CUDA/./-}  \
    cuda-cusparse-${CUDA/./-}  \
    libcudnn7=${CUDNN}+cuda${CUDA}  \
    # TensorFlow doesn't require libnccl anymore but Open MPI still depends on it
    libnccl2=2.4.7-1+cuda10.1  \
    libgomp1  \
    libnccl-dev=2.4.7-1+cuda10.1  \
    libfreetype6-dev  \
    libhdf5-serial-dev  \
    liblzma-dev  \
    libpng-dev  \
    libtemplate-perl  \
    libzmq3-dev  \
    curl  \
    git  \
    emacs  \
    wget  \
    vim  \
    libffi-dev  \
    libssl-dev  \
    libbz2-dev  \
    libreadline-dev  \
    libsqlite3-dev  \
    llvm  \
    libncurses5-dev  \
    libncursesw5-dev  \
    xz-utils  \
    tk-dev  \
    python-openssl  \
    openssh-client  \
    openssh-server  \
    zlib1g-dev  \
    # Install dependent library for OpenCV
    libgtk2.0-dev  \
    pkg-config  \
    software-properties-common  \
    unzip  

# Install TensorRT if not building for PowerPC
RUN [[ "${ARCH}" = "ppc64le" ]] || { apt-get update && \
    apt-get install -y --no-install-recommends libnvinfer${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda${CUDA} \
    libnvinfer-plugin${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda${CUDA} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*; }

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV LD_INCLUDE_PATH=/usr/local/cuda/include:/usr/local/cuda/extras/CUPTI/include:$LD_INCLUDE_PATH

# Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
# dynamic linker run-time bindings
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 \
    && echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf \
    && ldconfig

# More OpenCV stuff -- LibGL
# RUN apt-get install ffmpeg libsm6 libxext6  -y
# RUN apt-get install libgl1-mesa-glx
RUN apt-get update \
    && apt-get install -y libgl-dev

#Installing the python dependencies 
RUN apt-get update  \
  && apt-get install -y python3-pip python3-dev \
  && ln -s /usr/bin/python3 /usr/local/bin/python 

RUN chown -R datawhale:datawhale /home/datawhale
RUN pip3 install --upgrade pip



# Install graphtool

RUN apt-get install -y apt-utils wget bzip2

RUN apt-get install -y gcc g++
RUN apt-get install -y libboost-all-dev
RUN apt-get install -y libexpat1-dev
RUN apt-get install -y python3-scipy python3-numpy
RUN apt-get install -y libcgal-dev
RUN apt-get install -y libsparsehash-dev
RUN apt-get install -y libcairomm-1.0-dev
RUN apt-get install -y python3-cairo
RUN apt-get install -y python3-cairo-dev
RUN apt-get install -y python3-matplotlib
RUN apt-get install -y graphviz python3-pygraphviz
RUN apt-get install -y python3-pip

RUN apt-key adv --keyserver keys.openpgp.org --recv-key 612DEFB798507F25
RUN add-apt-repository "deb [ arch=amd64 ] https://downloads.skewed.de/apt bionic main"
RUN apt-get update
RUN apt-get install python3-graph-tool -y


RUN apt-get install -y gir1.2-gtk-3.0
RUN apt-get install -y vim bash-completion sudo
RUN apt-get install -y python3-gi-cairo













#Set the work directory to the datascience directory 
WORKDIR /home/datawhale

# Base stuff
ADD requirements_base.txt /home/datawhale/requirements_base.txt
RUN pip3 install -r requirements_base.txt  

# Other stuff
ADD requirements.txt /home/datawhale/requirements.txt
RUN pip3 install -r requirements.txt  

#Setting Jupyter notebook configurations 
RUN jupyter notebook --generate-config --allow-root
# RUN echo "c.NotebookApp.password = u'datawhale'" >> /home/datawhale/.jupyter/jupyter_notebook_config.py
# RUN echo "c.NotebookApp.token = 'datawhale'" >> /home/datawhale/.jupyter/jupyter_notebook_config.py

  

# RUN echo "export XDG_RUNTIME_DIR=''" >> ~/.bashrc
RUN chown -R datawhale:datawhale /home/datawhale



#Run the command to start the Jupyter server
# CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=.", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
