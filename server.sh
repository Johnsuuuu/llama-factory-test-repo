#!/bin/bash

exec > >(tee -i ./log/output.log)
exec 2>&1

set -e

# Function to execute a command and handle errors
exec_with_err_check() {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        exit $status
    fi
}

exec_with_err_check python3 ./update_api_yaml.py
echo "API yaml config file updated successfully."

echo "Starting server..."
exec_with_err_check llamafactory-cli api ./yaml/generated/api_config_updated.yaml