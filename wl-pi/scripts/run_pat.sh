#!/bin/sh
set -ex

pat --config /etc/${PAT_CONF:-pat.json} http
