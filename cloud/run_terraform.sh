#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "in directory: $(pwd)"
echo "changing to: $SCRIPT_DIR"
cd "$SCRIPT_DIR"


TERRAFORM_ARG=$1
if [[ "$TERRAFORM_ARG" == "init" ]]; then
  TERRAFORM_ARG="init"
elif [[ "$TERRAFORM_ARG" == "validate" ]]; then
  TERRAFORM_ARG="validate"
elif [[ "$TERRAFORM_ARG" == "destroy" ]]; then
  TERRAFORM_ARG="destroy -auto-approve"
elif [[ "$TERRAFORM_ARG" == "apply" ]]; then
  TERRAFORM_ARG="apply -auto-approve"
elif [ "$TERRAFORM_ARG" == "plan" ]; then
  TERRAFORM_ARG="plan"
else
  echo "only 'init', 'validate, 'plan', or 'apply' are valid"
  exit 1
fi

source .env

docker run  -it \
--mount "type=bind,source=$(pwd)/.aws/,target=/root/.aws" \
--mount "type=bind,source=$(pwd),target=/app" \
-e OPENAI_API_KEY="${OPENAI_API_KEY}" \
--workdir '/app/' \
hashicorp/terraform:latest $TERRAFORM_ARG

