#!/bin/sh

cd archiso

rm -rf out && rm -rf work && rm -rf archiso.log

./build.sh -v | tee -a archiso.log
