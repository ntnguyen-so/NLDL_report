#!/bin/bash

# Pull Intenet-available images
#docker pull r-base:4.1.0
docker pull maven:3.8.3-jdk-11-slim
docker pull numenta/nupic

# Build base image
cd 0-base-images
docker buildx build --platform linux/amd64, linux/arm64 -t registry.gitlab.hpi.de/akita/i/python3-base:0.2.5 ./python3-base
docker buildx build --platform linux/amd64, linux/arm64 -t registry.gitlab.hpi.de/akita/i/python3-torch:0.2.5 ./python3-torch
docker buildx build --platform linux/amd64, linux/arm64 -t registry.gitlab.hpi.de/akita/i/pyod:0.2.5 ./pyod
docker buildx build --platform linux/amd64, linux/arm64 -t registry.gitlab.hpi.de/akita/i/r-base ./r-base
docker buildx build --platform linux/amd64, linux/arm64 -t registry.gitlab.hpi.de/akita/i/tsmp:0.2.5 ./tsmp
docker buildx build --platform linux/amd64, linux/arm64 -t registry.gitlab.hpi.de/akita/i/java-base:0.2.5 ./java-base
docker buildx build --platform linux/amd64, linux/arm64 -t registry.gitlab.hpi.de/akita/i/python2-base:0.2.5 ./python2-base
docker buildx build --platform linux/amd64, linux/arm64 -t registry.gitlab.hpi.de/akita/i/python36-base:0.2.5 ./python36-base
docker buildx build --platform linux/amd64, linux/arm64 -t registry.gitlab.hpi.de/akita/i/r4-base:0.2.5 ./r4-base
docker buildx build --platform linux/amd64, linux/arm64 -t registry.gitlab.hpi.de/akita/i/rust-base:0.2.5 ./rust-base
docker buildx build --platform linux/amd64, linux/arm64 -t registry.gitlab.hpi.de/akita/i/timeeval-test-algorithm:0.2.5 ./timeeval-test-algorithm
cd ..

# For R-based programs
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
apt update
apt install r-base
Rscript -e 'install.packages("jsonlite")'
Rscript -e 'install.packages("tsmp")'
Rscript -e 'install.packages("PST")'
Rscript -e 'install.packages("TraMineR")'
Rscript -e 'install.packages("arules")'
Rscript -e 'install.packages("BBmisc")'

# Define the list of subfolders to ignore
ignored_folders=("01-data" "02-results" ".git" "0-base-images" "3-scripts")
univariable_algs=("numenta_htm" "health_esn" "ocean_wnn" "bagel" "donut" "img_embedding_cae" "sr_cnn")

# Get the list of sub-folders within the current folder, excluding the ones to ignore
subfolders=$(find . -mindepth 1 -maxdepth 1 -type d)

# Traverse through the list of sub-folders
for folder in $subfolders; do
	# Extract the name of the sub-folder
    folder_name=$(basename "$folder")
	# Check if the folder name is the list of supported algorithms
	if [[ "${univariable_algs[*]}" =~ $folder_name ]]; then
		# Pass the sub-folder name to the desired command
		echo "$folder_name"
		docker buildx build --platform linux/amd64, linux/arm64 -t adapad_$folder_name ./$folder_name || true
		# your_command "$folder_name"  # Replace "your_command" with the actual command you want to run	
	fi
	
done