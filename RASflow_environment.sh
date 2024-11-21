#!/bin/bash

ENV_NAME="RASflow"

if conda info --envs | grep -q "^$ENV_NAME[[:space:]]"; then
    echo "Environment '$ENV_NAME' already exists."
else
    conda env create -n "$ENV_NAME" -f env.yaml
    echo "Environment '$ENV_NAME' created."
fi

source activate $ENV_NAME
