#!/usr/bin/env bash
set -e

. $IDF_PATH/export.sh
. $ADF_PATH/esp-idf/export.sh

exec "$@"
