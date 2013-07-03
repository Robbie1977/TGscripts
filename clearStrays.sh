#!/bin/bash
#

#ps x | grep '~/DICE' | cut -b-5 | xargs kill
pgrep -u s1002628 -f DICEc | xargs kill
 
