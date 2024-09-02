#! /bin/bash

set -x

wget $VOCAB_URL -O /tmp/vocab.zip

mkdir /tmp/vocab
unzip /tmp/vocab.zip -d /tmp/vocab

Rscript /app/load_synthea.r
