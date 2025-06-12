*[main][~/Projects/helm/tests]$ time HELM_BIN=/opt/homebrew/bin/helm CONCURRENCY_COUNT=150 /bin/sh concurrency.sh > concurrency-without-fix.log
HELM_BIN=/opt/homebrew/bin/helm CONCURRENCY_COUNT=150 /bin/sh concurrency.sh   19,79s user 5,62s system 110% cpu 23,096 total

*[main][~/Projects/helm/tests]$ time HELM_BIN=/Users/artemvdovin/Projects/helm/tests/../bin/helm CONCURRENCY_COUNT=150 /bin/sh concurrency.sh > concurrency.log
HELM_BIN=/Users/artemvdovin/Projects/helm/tests/../bin/helm CONCURRENCY_COUNT  23,27s user 6,86s system 77% cpu 38,760 total
