A collection of singularity container definitions to help you build a singularity container with a sentiment analysis parser.

## Application Usage and Installation
First, build the image from the definition file

       >>> singularity build --fakeroot int_gradients_server.sif int_gradients_server_app.def

This container includes two applications, one for downloading the models and the other for setting up a server with these downloaded models. To run a specific model, you first have to download it with the `download_model` application, which will download the model to a specific location on the **host** *outside of the container*. To see all supported models, see the [Supported Applications section](#supported-applications)

     >>> singularity run --app download_model int_gradients_server.sif -m bert_imdb -p /path/to/download/location

After downloading a specific model, you can run it as a server with

      >>> singularity run --app run_server int_gradients_server.sif -f /path/to/model/ model_type --any_additional_flags

where `model_type` is one of `bert`, `xlnet_base`, or `xlnet_large`.

You can then curl the integrated gradients results from the running server in another shell window

    >>> curl http://localhost:8888/model/ --data @test_json.json --output my_output.gzip -H "Content-Type:application/json; chartset utf-8"

where the JSON file has only a 'sequence' field

      >>> cat test_json.json
      {"sequence": "This was a terrible movie!"}

### Supported Applications
Currently there are 12 model types that `download_model` can be run with:

  - `bert_imdb`
  - `bert_yelp`
  - `bert_sst_sentences`
  - `bert_sst_finetuned`
  - `xlnet_base_imdb`
  - `xlnet_base_yelp`
  - `xlnet_base_sst_sentences`
  - `xlnet_base_sst_finetuned`
  - `xlnet_large_imdb`
  - `xlnet_large_yelp`
  - `xlnet_large_sst_sentences`
  - `xlnet_large_sst_finetuned`

Receive further information on running servers with

	>>> singularity run --app run_server int_gradients_server.sif -h

### Supported Additional Flags
The possible flags that can currently be specified for these applications are:
    

 - `--baseline`: one of `pad`, `unk`, `zero`, `period`, `rand-norm`, `rand-unif` (required)
  - `--cuda/--cpu`: whether or not to run on CUDA device (required)
  - `--num-cuda-devs`: defaults to 1
  - `--host`: defaults to  `localhost`
  - `--port`: defaults to  `8888`

### Running on CUDA
Simply add the `--nv` flag to enable GPU usage within the singularity container.  Don't forget to specify the number of CUDA devices you want to work with!

       >>> singularity run --app run_server --nv int_gradients_server.sif -f /path/to/model xlnet_large --cuda --baseline pad --num-cuda-devices 4

### Obtainining Gradients
The gradients will then be stored in a dictionary with the keys "integrated_gradients", "intermediate_gradients", "step_sizes", and "intermediates".  They are then compressed and able to be retrieved from the saved gzip file with:

      >>> import gzip
      >>> import torch
      >>> from io import BytesIO
      >>> with gzip.open("my_output.gzip", 'rb') as fobj:
      >>>      x = BytesIO(fobj.read())
      >>>      grad_dict = torch.load(x)