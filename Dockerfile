FROM resin/rpi-raspbian:jessie

RUN apt-get -y update
RUN apt-get install -y python3-pip python3-dev
RUN apt-get install -y wget

RUN apt-get -y install libblas-dev liblapack-dev gfortran
RUN pip3 install numpy==1.12.1

RUN wget https://github.com/samjabrahams/tensorflow-on-raspberry-pi/releases/download/v1.1.0/tensorflow-1.1.0-cp34-cp34m-linux_armv7l.whl
RUN sudo pip3 install tensorflow-1.1.0-cp34-cp34m-linux_armv7l.whl

RUN apt-get -y install g++
RUN pip3 install scipy==0.19.0
RUN pip3 install keras==2.0.4

RUN apt-get install -y libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.5-dev tk8.5-dev python3-tk
RUN pip3 install pillow==4.1.1

RUN pip3 install docopt==0.6.2
RUN pip3 install tornado==4.5.1
RUN pip3 install requests==2.17.3

# TODO: Move this stuff up
RUN apt-get remove python-pip
RUN easy_install3 pip
RUN pip3 install envoy==0.0.3

ENV READTHEDOCS True
RUN pip3 install picamera==1.13

# First copy only setup.py, run pip install, and then copy the whole donkey dir.
# This is so only changes to setup.py trigger a pip install.
COPY ./setup.py /donkey/setup.py
RUN pip install -e /donkey/[pi]
COPY . /donkey/

# Change workdir and run scripts/setup.py
WORKDIR /donkey

# Run the driver
CMD ["python3", "/donkey/scripts/drive.py", "--config", "vehicle"]
