#!/bin/bash
### Bash script for downloading a certain model to a specified path utilizing environment variables from the singularity definition

usage () {
    echo "Usage: $0 [-m <string>] [-p <string>]"
    echo "Options:"
    echo "-m    Model name to download. One of bert_imdb, bert_yelp,"
    echo "      bert_sst_sentences, bert_sst_finetuned, xlnet_base_imdb,"
    echo "      xlnet_base_yelp, xlnet_base_sst_sentences,"
    echo "      xlnet_base_sst_finetuned, xlnet_large_imdb, xlnet_large_yelp,"
    echo "      xlnet_large_sst_sentences, xlnet_large_sst_finetuned."
    echo "-p    File path of the location to download the model."
}

while getopts ":h:m:p:" opt; do
    case ${opt} in
	h )
	    usage
	    exit 0
	    ;;
	m )
	    gdown_command=$"gdown_${OPTARG}"
	    model_name=${OPTARG}
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

if [[ -z "${!gdown_command}" ]] ; then
    echo "The option ${model_name} is not valid for download_model"
    exit 1
else
    gdown_url="${!gdown_command}"
    gdown ${gdown_url} -O ${download_path}
    exit 0
fi
