#!/bin/bash
#
# Need access to blazemeter/taurus image.
#
docker run -it --rm --name bzt -v "$(pwd)/taurus":/bzt-configs blazemeter/taurus testserver-taurus.yml