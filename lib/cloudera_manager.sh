#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2020-01-23 15:08:10 +0000 (Thu, 23 Jan 2020)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

# Quick lib to be sourced for auto-populating Cloudera Manager details in a script

# Tested on Cloudera Enterprise 5.10

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

if [ -z "${CLOUDERA_MANAGER:-}" ]; then
    if [ -n "${CLOUDERA_MANAGER_HOST:-}" ]; then
        CLOUDERA_MANAGER="${CLOUDERA_MANAGER_HOST:-}:${CLOUDERA_MANAGER_PORT:-7180}"
    else
        read -r -p 'Enter Clouder Manager host URL: ' CLOUDERA_MANAGER
    fi
fi

export USER="${CLOUDERA_MANAGER_USER:-${CLOUDERA_USER:-${USER:-}}}"
export PASSWORD="${CLOUDERA_MANAGER_PASSWORD:-${CLOUDERA_PASSWORD:-${PASSWORD:-}}}"

if [ -n "${CLOUDERA_MANAGER_SSL:-}" ]; then
    CLOUDERA_MANAGER="https://${CLOUDERA_MANAGER#*://}"
    if [[ "$CLOUDERA_MANAGER" =~ :7180$ ]]; then
        CLOUDERA_MANAGER="${CLOUDERA_MANAGER%:7180}:7183"
    fi
fi

# seems to work on CM / CDH 5.10.0 even when cluster is set to 'blah' but probably shouldn't rely on that
CLOUDERA_CLUSTER="${CLOUDERA_CLUSTER:-${CLOUDERA_MANAGER_CLUSTER:-}}"
if [ -z "${CLOUDERA_CLUSTER:-}" ]; then
    read -r -p 'Enter Cloudera Manager Cluster name: ' CLOUDERA_CLUSTER
fi

# 2020-01-02T16%3A17%3A57.514Z
# url encoding : => %3A seems to be done automatically by curl so not bothering to urlencode here
# shellcheck disable=SC2034
now_timestamp="$(date '+%Y-%m-%dT%H:%M:%S.000Z')"
