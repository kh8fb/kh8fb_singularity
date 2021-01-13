A collection of singularity container definitions to help you build a singularity container with state-of-the-art parsing capabilities.

## Application Usage and Installation
First, build the image from the definition file

       >>> singularity build --fakeroot lal_parser_server.sif lal_parser_server.def

This container includes two applications, one for downloading the model and the other for setting up a server with the downloaded model. To run a specific model, you first have to download it with the `download_model` application, which will download the model to a specific location on the **host** *outside of the container*. Note that this model is 5.2GB.

     >>> singularity run --app download_model lal_parser_server.sif -p /path/to/download/location

After downloading the model, you can run it as a server with

      >>> singularity run --app run_server lal_parser_server.sif -f /path/to/model.pt lal --any_additional_flags

You can then curl the parsed sentences from the running server in another shell window

    >>> curl http://localhost:8888/model/ --data @test_json.json --output my_output.json -H 'Content-Type:application/json; chartset utf-8'

where the JSON file has a 'sequences' field filled with 'ids' and the sentences to parse.

      >>> cat test_json.json
      {"sequences": {"1": "This is the first input phrase.","2": "This is the last and final input phrase?"}}
      >>> cat my_output.json
      {"Dependencies": {"1": "(S (NP (DT This)) (VP (VBZ is) (NP (DT the) (JJ first) (NN input) (NN phrase))) (. .))", "2": "(S (NP (DT This)) (VP (VBZ is) (NP (DT the) (ADJP (JJ last) (CC and) (JJ final)) (NN input) (NN phrase))) (. ?))"}}

As you can tell these IDs are also included in the output, allowing you to easily index the sentences.

### Supported Additional Flags
The possible flags that can currently be specified for these applications are:
    
  - `--cuda/--cpu`: whether or not to run on CUDA device (required)
  - `--host`: defaults to  `localhost`
  - `--port`: defaults to  `8888`

### Running on CUDA
Simply add the `--nv` flag to enable GPU usage within the singularity container.  Don't forget to specify the number of CUDA devices you want to work with!

       >>> singularity run --app run_server --nv lal_parser_server.sif -f /path/to/model xlnet_large --cuda --baseline pad --num-cuda-devices 4

