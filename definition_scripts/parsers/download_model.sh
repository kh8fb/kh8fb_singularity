#!/bin/bash
### Bash script for downloading a the LAL-Parser model to a specified path utilizing environment variables from the singularity definition

export gdown_lal_link="https://drive.google.com/uc?id=1LC5iVcvgksQhNVJ-CbMigqXnPAaquiA2"

usage () {
    echo "Usage: $0 [-m <string>] [-p <string>]"
    echo "Options:"
    echo "-p    File path of the location to download the model."
}

while getopts ":h:p:" opt; do
    case ${opt} in
	h )
	    usage
	    exit 0
	    ;;
	p )
	    download_path="$OPTARG"
	    ;;
	\? )
            echo "Invalid Option: -$OPTARG"
            usage
            exit 1
        ;;
        : )
            echo "Invalid Option: $OPTARG requires an argument"
            usage
            exit 1
        ;;
    esac
done

if [[ -z "${download_path}" ]] ; then
    exit 1
else
    gdown "$gdown_lal_link" -O ${download_path}
    exit 0
fi
