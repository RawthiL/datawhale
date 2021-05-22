FROM nvidia/cuda:11.0.3-cudnn8-devel-ubuntu20.04


ENV TZ=America/Argentina
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated  \
    build-essential  \
    ca-certificates  \
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
    unzip  \
    nano


# More OpenCV stuff -- LibGL
# RUN apt-get install ffmpeg libsm6 libxext6  -y
# RUN apt-get install libgl1-mesa-glx
RUN apt-get update \
    && apt-get install -y libgl-dev

#Installing the python dependencies 
RUN apt-get update  \
  && apt-get install -y python3-pip python3-dev \
  && ln -s /usr/bin/python3 /usr/local/bin/python 



RUN useradd -ms /bin/bash datawhale
RUN su datawhale

RUN chown -R datawhale:datawhale /home/datawhale
RUN pip3 install --upgrade pip


# Graphviz for Keras model plot
RUN apt-get install -y graphviz python3-pygraphviz


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

RUN apt-get install -y gir1.2-gtk-3.0
#RUN apt-get install -y vim bash-completion sudo
RUN apt-get install -y python3-gi-cairo

RUN echo "deb [ arch=amd64 ] https://downloads.skewed.de/apt focal main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keys.openpgp.org --recv-key 612DEFB798507F25
RUN add-apt-repository "deb [ arch=amd64 ] https://downloads.skewed.de/apt focal main"
RUN apt-get update
RUN apt-get install python3-graph-tool -y



# Install tesseract-ocr

RUN apt-get install -y tesseract-ocr










#Set the work directory to the datascience directory 
WORKDIR /home/datawhale

# Base stuff
ADD requirements_base.txt /home/datawhale/requirements_base.txt
RUN pip3 install -r requirements_base.txt  

# Other stuff
ADD requirements.txt /home/datawhale/requirements.txt
RUN pip3 install -r requirements.txt  



#Setting Jupyter notebook configurations 
RUN su datawhale
RUN mkdir /home/datawhale/.jupyter/
RUN jupyter notebook --generate-config --allow-root
# Make connection easy
#RUN mkdir /home/datawhale/.jupyter/
RUN echo "c.NotebookApp.token = ''" > /home/datawhale/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.password = ''" >> /home/datawhale/.jupyter/jupyter_notebook_config.py
# Make it (more) insecure to be able to use the plot function of pyntcloud in jupyther...
RUN echo "c.NotebookApp.allow_origin = '*' #allow all origins" >> /home/datawhale/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.disable_check_xsrf = True" >> /home/datawhale/.jupyter/jupyter_notebook_config.py



# RUN echo "export XDG_RUNTIME_DIR=''" >> ~/.bashrc
RUN chown -R datawhale:datawhale /home/datawhale


#Run the command to start the Jupyter server
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
