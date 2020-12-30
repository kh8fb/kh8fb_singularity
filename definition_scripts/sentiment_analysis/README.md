A collection of singularity container definitions to help you build a singularity container with a sentiment analysis parser.

## Application Usage and Installation
First, build the image from the definition file

       >>> sudo singularity build --sandbox int_gradients_server.sif int_gradients_server_app.def

This package includes numerous apps for use cases with different model types.  To see all supported models, see the [Supported Applications section](#supported-applications) To run a specific model, you first have to download it with the `download_model` application.

     >>> sudo singularity run -w --app download_model int_gradients_server.sif/ bert_imdb

After downloading a specific model, you can run it as a server with

      >>> singularity run --app bert_imdb int_gradients_server.sif --any_other_flags
     
You can then curl the integrated gradients results from the running server in another shell window

    >>> curl http://localhost:8888/model/ --data @test_json.json --output my_output.gzip -H "Content-Type:application/json; chartset utf-8"

where the JSON file has only a 'sequence' field

      >>> cat test_json.json
      {"sequence": "This was a terrible movie!"}

### Supported Applications
Currently there are 12 supported applications that `app_name` can be replaced with:
	  * `bert_imdb`
	  * `bert_yelp`
	  * `bert_sst_sentences`
	  * `bert_sst_finetuned`
	  * `xlnet_base_imdb`
	  * `xlnet_base_yelp`
	  * `xlnet_base_sst_sentences`
	  * `xlnet_base_sst_finetuned`
	  * `xlnet_large_imdb`
	  * `xlnet_large_yelp`
	  * `xlnet_large_sst_sentences`
	  * `xlnet_large_sst_finetuned`

Receive further information on each of these applications with

	>>> singularity apps --help int_gradients_server.sif

### Supported Flags
The possible flags that can currently be specified for these applications are:
    * `--baseline`: one of `pad`, `unk`, `zero`, `period`, `rand-norm`, `rand-unif` (required)
    * `--cuda/--cpu`: whether or not to run on CUDA device (required)
    * `--num-cuda-devs`: defaults to 1
    * `--host`: defaults to  `localhost`
    * `--port`: defaults to  `8888`


CUDA support will be added in the future.

### Running on CUDA


### Obtainining Gradients
The gradients will then be stored in a dictionary with the keys "integrated_gradients", "intermediate_gradients", "step_sizes", and "intermediates".  They are then compressed and able to be retrieved from the saved gzip file with:

      >>> import gzip
      >>> import torch
      >>> from io import BytesIO
      >>> with gzip.open("saved_file.gzip", 'rb') as fobj:
      >>>      x = BytesIO(fobj.read())
      >>>      grad_dict = torch.load(x)

