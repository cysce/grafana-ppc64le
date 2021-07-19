
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
  printf "* Error: Invalid argument. missing --base=/Volumes/DATA/CYSCE/COC2 --base=/home/cocdata/grafana \n"
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

rm -rf ${base}/grafana-ppc64le/temp
mkdir ${base}/grafana-ppc64le/temp
cat ${base}/grafana-ppc64le/k8s/grafana.template | sed "s#<HOST>#$host#g" > ${base}/grafana-ppc64le/temp/grafana01.template
cat ${base}/grafana-ppc64le/temp/grafana01.template | sed "s#<PATH>#$base#g" > ${base}/grafana-ppc64le/temp/deployment.yaml

kubectl create configmap cysce-grafana --from-file=${base}/grafana-ppc64le/k8s/grafana.ini
kubectl apply -f ${base}/grafana-ppc64le/temp/deployment.yaml
kubectl apply -f ${base}/grafana-ppc64le/k8s/ingress.yaml
