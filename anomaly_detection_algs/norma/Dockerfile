FROM registry.gitlab.hpi.de/akita/i/python3-base:0.2.5

LABEL maintainer="ntng@hvl.no"

ENV ALGORITHM_MAIN="/app/algorithm.py"

RUN apt-get update && \
    apt-get -y install gcc mono-mcs && \
    rm -rf /var/lib/apt/lists/*
    
COPY requirements.txt /app/
RUN pip3 install Cython
RUN pip install -r requirements.txt
RUN pip3 install matrixprofile

COPY algorithm.py /app/
