# ESP DOCKER
This project contains the esp-idf, esp-adf and the esp rtos sdk in a dockerized form.

There are shell scripts to help perform common tasks when developing for espressif boards.

## Why not use PlatformIO?
- Currently, the latest version of the rtos-sdk is not available on PlatformIO.
- The esp adf is also not available on PlatformIO.

## Why not just install the IDF's and toolchains on your machine?
- Using docker makes it easy to spin up development environments and tools with a single command.
- Docker also allows you to change IDF, ADF and RTOS SDK versions by changing a single variable.
- Everyone is entitled to their preferences but if you're looking for this tool, you probably like Docker.

## Included scripts
- `adf.sh`
- `idf.sh`
- `rtos-sdk.sh`

These scripts are pretty rudimentary at the moment. Feel free to add any needed commands during development or create a PR to improve them.

## Commands
### `idf.sh` and `adf.sh` commands

The following are using `idf.sh` but are all interchangable with `adf.sh`

`./idf.sh bash`

`./idf.sh build`

`./idf.sh create` Create a container from the image.

`./idf.sh examples ls <path=nullable>` List examples from ESP IDF.

`./idf.sh examples cp <example_path> <project_path>` Copy an example from the ESP IDF for your project.

`./idf.sh make`

`./idf.sh flash`

`./idf.sh monitor`

`./idf.sh idfpy <idf.py command>`

## Feel Free to Submit a PR
This project has been cobbled together on a need to need basis so there is a lot of room for improvement.

If you can think of something that is not on the following clean-up list, feel free to add to it by submitting a PR with the updated list.

Here is a list of some cleanup items:
- Improve CLI
- Create `help` command
- Consolidate shell scripts
