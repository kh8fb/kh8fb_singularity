#!/bin/bash
### Bash script for running an int-gradients-server from a singularity container

usage () {
    echo "Usage: $0 [-f <string>] [additional_args]"
    echo "Options:"
    echo ""
    echo "-f          Path to the model file"
    echo "additional_args: Arguments for the server's specifications"
    echo ""
    echo "--cuda/--cpu <required>:   Whether to run the models on cuda or cpu"
    echo "--host:                    Host of the server. Defaults to localhost"
    echo "--port:                    Port to run server on. Defaults to 8888"
}

run_server() {
    lal-parser-server -mp "$file_path" "$@"
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

"run_server" "$@"
exit 0
