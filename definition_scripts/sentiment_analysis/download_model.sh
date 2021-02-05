#!/bin/bash
### Bash script for downloading a certain model to a specified path utilizing environment variables from the singularity definition

export gdown_bert_imdb="https://drive.google.com/uc?id=1R_7SVjETSHs74ff2ita7PrahcFbM1gZa"
export gdown_bert_yelp="https://drive.google.com/uc?id=1h7jmjlPl6KPqVHhQo9FnVpZtg2h-14-7"
export gdown_bert_sst_sentences="https://drive.google.com/uc?id=1XSeRl5dHCAabB-gTbhYiZVO3JsA4OixJ"
export gdown_bert_sst_finetuned="https://drive.google.com/uc?id=19gRGkWKA4-pOH-TTQG5wEmA2wwtOOFoi"
export gdown_xlnet_base_imdb="https://drive.google.com/uc?id=1mTfHTA5kdlQLFRtLGZPRTLHTB8nNL-du"
export gdown_xlnet_base_yelp="https://drive.google.com/uc?id=1M63fFr4sAhrZ-mNdIJdU8tRUxhzkeQ7j"
export gdown_xlnet_base_sst_sentences="https://drive.google.com/uc?id=18fr8RLFiakDrFf24Dxsw88Uypqfp0B_b"
export gdown_xlnet_base_sst_finetuned="https://drive.google.com/uc?id=1K7u0nGi5Ecc8g4A8KEgngDpRs6X5n0Dm"
export gdown_xlnet_large_imdb="https://drive.google.com/uc?id=1B11ko7Dzam3ZxaHE_GWhD_uMLK5ZNGpO"
export gdown_xlnet_large_yelp="https://drive.google.com/uc?id=1R_7SVjETSHs74ff2ita7PrahcFbM1gZa"
export gdown_xlnet_large_sst_sentences="https://drive.google.com/uc?id=12qqdcZgb7UUvmzMVR__maUvz1l5ZNLrL"
export gdown_xlnet_large_sst_finetuned="https://drive.google.com/uc?id=1R_7SVjETSHs74ff2ita7PrahcFbM1gZa"

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
    gdown ${gdown_url} -O "${download_path}"
    exit 0
fi
