#!/usr/bin/env bash

initial_label='      - Label:
          default: "App Specific Parameters"
        Parameters:\n'
while read line
do
    initial_label+="          - "$line"\n"
done < AppSpecifications.txt
awk -v INITIAL="$initial_label" '{ sub(/#APP_SPECIFIC_PARAMETERS/, INITIAL); print; }' pipeline.template > pipeline1.yaml


params='    Type: String
    Description: App Specific Parameter\n'
while read line
do
    final_params+="  "$line":\n"
    final_params+=$params
done < AppSpecifications.txt
awk -v FINAL="$final_params" '{ sub(/#PARAMETERS_DESCRIPTION/, FINAL); print; }' pipeline1.yaml > pipeline2.yaml
rm pipeline1.yaml

build_params_name='          - Name: '
build_params_value='            Value: !Ref '
build_params=''
while read line
do
    build_params+=$build_params_name${line^^}"\n"
    build_params+=$build_params_value${line}"\n"
done < AppSpecifications.txt
awk -v BUILD="$build_params" '{ sub(/#CODE_BUILD_ENV/, BUILD); print; }' pipeline2.yaml > pipeline.yaml
rm pipeline2.yaml
