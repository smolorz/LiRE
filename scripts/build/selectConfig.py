#!/usr/bin/env python

import os
import sys

#exit code 1 = error, something went wrong
#exit code 2 = no configs present
#exit code 3 = couldn't determine the latest config 
#              (some configs have the same version and date)
def configStringArrayToString(stringArray):
    result = ''
    for part in stringArray:
        if(result != ''):
            result += '-'
        result += part
    return result

working_dir = os.getcwd()
if(working_dir.split('/')[-1] != 'configs'):
    sys.exit(1)

if(len(os.listdir(working_dir)) == 0):
    sys.exit(2)


configs = []

for config in os.listdir(working_dir):
    if( len(config.split('-')) > 1):
        configs.append(config.split('-'))

#sort by version-string part of config name
version_index = 0
while(len(configs) > 1 and len(configs[0][1].split('.')) > version_index):
   biggest_version = 0
   #remove every config from list, that version part is smaller than the biggest
   changed_something = True
   while(changed_something):
       changed_something = False
       for config in configs:
           if(len(config[1].split('.')) <= version_index and len(configs) > 1):
                   configs.remove(config)
                   continue
           config_version_part = int(config[1].split('.')[version_index])
           if(config_version_part > biggest_version):
               biggest_version = config_version_part
               changed_something = True
           elif (config_version_part < biggest_version):
               configs.remove(config)
               changed_something = True
   version_index += 1

#sort by date part of version string
if(len(configs) > 1):
    #remove version without date, because per convention
    #a file without date is smaller than a file with date 
    for config in configs:
        if(len(config) < 3 or len(config[2].split('.')) != 3):
            configs.remove(config)
    biggest_date = 0
    #remove every config from list, that date part is smaller than the biggest
    changed_something = True
    date_index = 0
    while(date_index < 3 and len(configs) > 1):
        changed_something = True
        biggest_date = 0
        while(changed_something):
            changed_something = False
            for config in configs:
                config_date_part = int(config[2].split('.')[date_index])
                if(config_date_part > biggest_date):
                    biggest_date = config_date_part
                    changed_something = True
                elif (config_date_part < biggest_date):
                    configs.remove(config)
                    changed_something = True
        date_index += 1


if(len(configs) > 1):
    sys.exit(3)

print configStringArrayToString(configs[0])



