#!/bin/bash

set -ex

bin/setup.sh
sudo -E NODE_ENV='app' bin/mitamae local "$@" lib/recipe.rb
