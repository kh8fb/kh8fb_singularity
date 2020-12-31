#!/bin/bash
### Bash script for running an int-gradients-server from a singularity container

usage () {
    echo "Usage: $0 [-f <string>] [bert|xlnet_base|xlnet_large] [additional_args]"
    echo "Options:"
    echo ""
    echo "-f          Path to the model file"
    echo "bert        Specify this option if a BERT model is supplied"
    echo "xlnet_base  Specify this option if an xlnet base model is supplied."
    echo "xlnet_large Specify this option if an xlnet large model is supplied."
    echo ""
    echo "additional_args: Arguments for the server's specifications"
    echo ""
    echo "--baseline/-b <required>:  Baseline type. One of (pad, unk, zero,"
    echo "                           rand-norm, rand-unif, or period)"
    echo "--cuda/--cpu <required>:   Whether to run the models on cuda or cpu"
    echo "--num-cuda-devs:           Number of cuda devices available for server"
    echo "--host:                    Host of the server. Defaults to localhost"
    echo "--port:                    Port to run server on. Defaults to 8888"
}

run_bert () {
    intgrads -bp "$file_path" "$@"
}
run_xlnet_large () {
    intgrads -xll "$file_path" "$@"
}
run_xlnet_base () {
    intgrads -xlb "$file_path" "$@"
}

while getopts ":hf:" opt; do
    case ${opt} in
	h )
	    usage
	    exit 0
	    ;;
	f )
	    file_path="$OPTARG"
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
shift $((OPTIND -1))

if [[ -z "$1" ]] ; then
    SUBCOMMAND="default"
else
    SUBCOMMAND="$1"
    shift 1
fi

if [[ "$( type -t "run_${SUBCOMMAND}" )" != "function" ]] ; then
    echo "Invalid command: $SUBCOMMAND"
    usage
    exit 1
fi

"run_${SUBCOMMAND}" "$@"
exit 0
