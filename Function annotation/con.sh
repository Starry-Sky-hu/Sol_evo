#!/bin/bash

for i in $(cat f_all_list)
do
        mkdir -p ${i}
        cd ${i}
        cp ../Template.sh ${i}_work.sh
        sed -i 's/test/'${i}'/g' ${i}_work.sh
        cd ..
done
