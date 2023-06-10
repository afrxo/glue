#!/bin/bash

project=bundle.project.json
project_output=bundle.rbxl
output=Glue

rojo build $project -o $project_output
lune build $project_output $output
echo "Built $output.rbxm"