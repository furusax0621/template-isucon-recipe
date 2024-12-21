#!/bin/bash

set -ex

bin/setup.sh
sudo -E NODE_ENV='monitor' bin/mitamae local "$@" lib/recipe.rb
