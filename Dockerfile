FROM 32bit/ubuntu:16.04

RUN rm /etc/apt/sources.list
RUN add-apt-repository main
RUN apt-get update
RUN apt-get install wget -y

#https://askubuntu.com/questions/760896/how-can-i-automatically-fix-w-target-packages-is-configured-multiple-times
#RUN sudo apt install python3-apt -y
#RUN wget https://raw.githubusercontent.com/davidfoerster/apt-remove-duplicate-source-entries/master/apt-remove-duplicate-source-entries.py
#RUN chmod +x apt-remove-duplicate-source-entries.p
#USER root
#RUN  ./apt-remove-duplicate-source-entries.py


ENV HOME="/home/builder"
RUN mkdir -p $HOME

#RUN apt-get install -y ca-certificates
#RUN apt-get update
#RUN apt-get install -y git #E: Unable to locate package git



RUN mkdir wine/

WORKDIR wine/

RUN wget   http://dl.winehq.org/wine/source/2.0/wine-2.0.2.tar.xz
RUN tar -xf wine-2.0.2.tar.xz

WORKDIR wine-2.0.2/

#RUN ./configure  --without-x  --without-freetype --enable-win64
RUN ./configure  --without-x  --without-freetype
RUN make
RUN make install

WORKDIR ../../wine/


ENV CC="/usr/local/bin/winegcc" \
    CXX="/usr/local/bin/wineg++"
