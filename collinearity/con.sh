for i in $(cat list)
do
    mkdir ${i}
    cd ${i}
    cp ../genetribe.sh ${i}_genetribe.sh
    sed -i 's/protein/'${i}'/g' ${i}_genetribe.sh
    cd ..
done

