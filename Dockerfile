# NOTE: this example is taken from the default Dockerfile for the official nginx Docker Hub Repo
# https://hub.docker.com/_/nginx/
# NOTE: This file is slightly different than the video, because nginx versions have been updated 
#       to match the latest standards from docker hub... but it's doing the same thing as the video
#       describes
FROM centos:7
# all images must have a FROM
# usually from a minimal Linux distribution like debian or (even better) alpine
# if you truly want to start with an empty container, use FROM scratch
MAINTAINER Yavdhesh Sanchihar "1009045"

ENV TESSDATA_PREFIX=/usr/share/tesseract/4/tessdata
# optional environment variable that's used in later lines and set as envvar when container is running

#RUN mkdir -p /usr/share/tessdata && mkdir -p /usr/share/info && mkdir -p /usr/local/share/tessdata

#fast_data
#ADD https://github.com/tesseract-ocr/tessdata_fast/blob/master/eng.traineddata /usr/share/tessdata/eng.traineddata
#ADD https://github.com/tesseract-ocr/tessdata_fast/blob/master/enm.traineddata /usr/share/tessdata/enm.traineddata	
#ADD https://github.com/tesseract-ocr/tessdata_fast/blob/master/eng.traineddata /usr/local/share/tessdata/eng.traineddata
#ADD https://github.com/tesseract-ocr/tessdata_fast/blob/master/enm.traineddata /usr/local/share/tessdata/enm.traineddata	

#https://github.com/tesseract-ocr/tessdata/blob/master/eng.traineddata

#saamaanya data
#ADD https://github.com/tesseract-ocr/tessdata/blob/master/eng.traineddata /usr/share/tessdata/eng.traineddata
#ADD https://github.com/tesseract-ocr/tessdata/blob/master/enm.traineddata /usr/share/tessdata/enm.traineddata	
#ADD https://github.com/tesseract-ocr/tessdata/blob/master/eng.traineddata /usr/local/share/tessdata/eng.traineddata
#ADD https://github.com/tesseract-ocr/tessdata/blob/master/enm.traineddata /usr/local/share/tessdata/enm.traineddata	

#https://github.com/tesseract-ocr/tessdata_best/blob/master/eng.traineddata

#ADD https://github.com/tesseract-ocr/tessdata_best/blob/master/eng.traineddata /usr/share/tessdata/eng.traineddata
#ADD https://github.com/tesseract-ocr/tessdata_best/blob/master/enm.traineddata /usr/share/tessdata/enm.traineddata	
#ADD https://github.com/tesseract-ocr/tessdata_best/blob/master/eng.traineddata /usr/local/share/tessdata/eng.traineddata
#ADD https://github.com/tesseract-ocr/tessdata_best/blob/master/enm.traineddata /usr/local/share/tessdata/enm.traineddata	

#RUN chmod -R 777 /usr/share/tessdata/ && chmod -R 777 /usr/local/share/tessdata/

RUN yum -y update \
    && yum erase openscap \
	&& yum -y install openscap-scanner \
	&& yum -y install wget libstdc++ autoconf automake libtool autoconf-archive pkg-config gcc gcc-c++ make libjpeg-devel libpng-devel libtiff-devel zlib-devel \
	&& yum -y install epel-release


# optional commands to run at shell inside container at build time
# this one adds package repo for nginx from nginx.org and installs it

RUN yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/Alexander_Pozdnyakov/CentOS_7/home:Alexander_Pozdnyakov.repo \
	&& rpm --import https://build.opensuse.org/projects/home:Alexander_Pozdnyakov/public_key \
	&& yum -y update \
	&& yum -y install tesseract \
	&& yum -y install tesseract-langpack-eng \
	&& yum -y install tesseract-langpack-enm

#GUI dependencies
RUN yum -y install libXext \
	&& yum -y install libSM \
	&& yum -y install libXrender
	
RUN yum -y install python3 \
	&& yum -y install python36-devel 

RUN mkdir -p /appOCR	
COPY Code /appOCR/
WORKDIR /appOCR

#RUN apppath="$(ls -lrt )" && echo $apppath && pth="$(pwd )" && echo $pth \
#		&& tesdatdir="$(ls -lrt /usr/share/tessdata/)" && echo $tesdatdir

#ENV TESSDATA_PREFIX=/usr/share/tesseract/4/tessdata
		
#RUN ["chmod", "+x", "/appOCR/app.py"]	

RUN pip3 install pillow \
	&& pip3 install pytesseract \
	&& pip3 install opencv-contrib-python-headless \
	&& pip3 install -r requirements.txt
# forward request and error logs to docker log collector

EXPOSE 80 443 5000
# expose these ports on the docker virtual network
# you still need to use -p or -P to open/forward these ports on host

#ENTRYPOINT ["python3"]
CMD ["python3","app.py"]
# required: run this command when container is launched
# only one CMD allowed, so if there are multiple, last one wins
