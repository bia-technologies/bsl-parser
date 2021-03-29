#!/bin/bash
rm "*.ospx"

result=$(oscript -version)

if [[ $result = "1.0.19.105" ]]; then
	opm build . -mf ./packagedef -out .
else
	opm build -m ./packagedef -o .
fi

opm install -f *.ospx
