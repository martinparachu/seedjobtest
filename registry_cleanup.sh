#!/usr/bin/env bash
echo "arranca"

REPO=localhost:5000
KEEPTAG=3
SKIPTAG=( development staging validation )

curl -s http://${REPO}/v2/_catalog

CheckTag(){
    Name=$1
    Tag=$2

    Skip=0
    Match=$(echo "${SKIPTAG[@]}" | grep -o "${Tag}")
    if [[ ! -z $Match ]]; then
        Skip=1
    fi
	
    if [[ "${Skip}" == "1" ]]; then
        echo "skip ${Name} ${Tag}"
    else
        Sha=$(curl -v -s -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X GET http://${REPO}/v2/${Name}/manifests/${Tag} 2>&1 | grep Docker-Content-Digest | awk '{print ($3)}')
        Sha="${Sha/$'\r'/}"
        echo "delete ${Name} ${Tag} ${Sha}"
        curl -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -X DELETE "http://${REPO}/v2/${Name}/manifests/${Sha}" 1> removed.txt
    fi
}

ScanRepository(){
    Name=$1
    echo "Repository ${Name}"
    curl -s http://${REPO}/v2/${Name}/tags/list | jq '.tags[]' | sort -r | tail -n +$((KEEPTAG+1)) |
    while IFS=$"\n" read -r line; do
        line="${line%\"}"
        line="${line#\"}"
        CheckTag $Name $line
    done
}


curl -s http://${REPO}/v2/_catalog | jq '.repositories[]' |
while IFS=$"\n" read -r line; do
    line="${line%\"}"
    line="${line#\"}"
    ScanRepository $line
done

echo "termina"
