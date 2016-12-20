#!/bin/sh
cd /home/app
#/opt/activator/bin/activator 'reboot full'
/opt/activator/bin/activator -jvm-debug 9999 run
