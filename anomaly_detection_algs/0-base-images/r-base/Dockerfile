FROM ubuntu:20.04

RUN apt-get install software-properties-common & apt-get update
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/' & apt-get update & apt-get install -y r-base

RUN set -eux; \
    R -e 'install.packages("jsonlite")'; \
	R -e 'install.packages("tsmp")'; 

# Setup TimeEval integration

VOLUME ["/data", "/results"]

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "execute-algorithm" ]
