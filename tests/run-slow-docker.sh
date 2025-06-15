if [ "$1" == "local" ]; then
docker run --rm -it \
  -v $(pwd)/../:/helm-dir \
  golang:1.24 \
  sh -c "
    set -e
    apt update && apt install -y bash make git
    cd /helm-dir/ && (rm ./bin/helm || true) && make && chmod +x ./bin/helm &&
    cd tests && chmod +x concurrency.sh &&
    export HELM_CONFIG_HOME=/helm-workdir &&
    export HELM_CACHE_HOME=/helm-workdir &&
    export HELM_DATA_HOME=/helm-workdir &&
    CONCURRENCY_COUNT=250 HELM_BIN=/helm-dir/bin/helm /bin/bash ./concurrency.sh
  "
fi

if [ "$1" == "remote" ]; then
docker run --rm -it \
  -v $(pwd)/../:/helm-dir \
  golang:1.24 \
  sh -c "
    set -e
    apt update && apt install -y bash make git
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    cd /helm-dir/tests && chmod +x concurrency.sh &&
    export HELM_CONFIG_HOME=/helm-workdir &&
    export HELM_CACHE_HOME=/helm-workdir &&
    export HELM_DATA_HOME=/helm-workdir &&
    CONCURRENCY_COUNT=250 HELM_BIN=/usr/local/bin/helm /bin/bash ./concurrency.sh
  "
fi

