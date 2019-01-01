#!/bin/sh

cd archiso

./build.sh -v | tee -a archiso.log
