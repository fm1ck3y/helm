docker run --rm -it \
  --tmpfs /helm-workdir:size=100M,mode=0777 \
  -v $(pwd)/helm-workdir/repositories.yaml:/helm-workdir/repositories.yaml \
  -v $(pwd)/../:/helm-dir \
  golang:1.24 \
  sh -c "
    apt update && apt install -y bash make git gcc &&
    cd /helm-dir/ && (rm ./bin/helm || true) && make && chmod +x ./bin/helm &&
    cd tests && chmod +x concurrency.sh &&
    gcc -shared -fPIC -o /tmp/slowio.so slowio.c -ldl &&
    export HELM_CONFIG_HOME=/helm-workdir &&
    export HELM_CACHE_HOME=/helm-workdir &&
    export HELM_DATA_HOME=/helm-workdir &&
    CONCURRENCY_COUNT=30 LD_PRELOAD=/tmp/slowio.so HELM_BIN=/helm-dir/bin/helm /bin/bash ./concurrency.sh
  "

