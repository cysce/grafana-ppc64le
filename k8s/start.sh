
#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
    --base=*)
      base="${1#*=}"
      ;;
    --host=*)
      host="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done
echo base $base
echo host $host

if [[ $base == '' ]]
then
  printf "*******************************************************************************\n"
  printf "* Error: Invalid argument. missing --base=/Volumes/DATA/CYSCE/COC2/grafana/data \n"
  printf "*******************************************************************************\n"
  exit 1
fi

if [[ $host == '' ]]
then
  printf "*******************************************************************************\n"
  printf "* Error: Invalid argument. missing --host=grafana.cysce.com \n"
  printf "*******************************************************************************\n"
  exit 1
fi

rm -rf ${base}/temp
mkdir ${base}/temp
cat ${base}/k8s/dev/grafana.template | sed "s#<HOST>#$host#g" > ${base}/temp/grafana01.template
cat ${base}/temp/grafana01.template | sed "s#<PATH>#$base#g" > ${base}/temp/deployment.yaml

kubectl create configmap coc-v2-grafana --from-file=${base}/grafana.ini
kubectl apply -f ${base}/temp/deployment.yaml
