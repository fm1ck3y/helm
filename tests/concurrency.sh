#!/bin/sh

set -e

HELM_BIN=${HELM_BIN:-$(pwd)/../bin/helm}
CONCURRENCY_COUNT="${CONCURRENCY_COUNT:=5}"
TEMP_DIR=$(mktemp -p $(pwd) -d)

export HELM_CONFIG_HOME=${HELM_CONFIG_HOME:-$(pwd)/helm-workdir}
export HELM_CACHE_HOME=${HELM_CACHE_HOME:-$(pwd)/helm-workdir}
export HELM_DATA_HOME=${HELM_DATA_HOME:-$(pwd)/helm-workdir}

mkdir -p $HELM_CONFIG_HOME

helmtemplate() {
  cd $TEMP_DIR/$1
  ($HELM_BIN --debug dependency build && $HELM_BIN template . > /dev/null) \
    && echo "$1 success" || echo "$1 failed"
}

helmrepoupdate(){
  $HELM_BIN repo add company https://charts.companyinfo.dev
  $HELM_BIN repo add helmize https://helmize.dev/
  ($HELM_BIN --debug repo update) && echo "helm repo update success" || echo "helm repo update failed"
}

flowdepbuild(){
 cd $TEMP_DIR/$1
 helmtemplate $1 
}

helmrepoupdate

helmrepoupdate &
for i in $(seq 0 $CONCURRENCY_COUNT); do 
 cp -r $(pwd)/charts/my-concurency-chart $TEMP_DIR/my-concurency-chart-${i}
 (flowdepbuild "my-concurency-chart-$i") &
 sleep 0.02
 pids+=("$!")
done

for pid in ${pids[@]}; do
    wait $pid
done

rm -rf $TEMP_DIR
