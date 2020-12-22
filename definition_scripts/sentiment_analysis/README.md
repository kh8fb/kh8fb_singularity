A collection of singularity container definitions to help you build a singularity container with a sentiment analysis parser.

## Using these scripts
First, build the image from the definition file

       singularity build my_image.sif my_image.def

Next, run the image, binding a directory for the data to enter or leave with the /mnt or /tmp directory of the container

      singularity shell --bind /path/to/my_data_folder:/mnt

