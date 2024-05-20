#!/bin/bash

az account set --subscription 'Visual Studio Professional-abonnement'

az deployment sub create --name saga-infrastructure \
    --location 'westeurope' --template-file main.bicep

echo 'Infrastructure created'