#!/bin/sh
set -ex

direwolf -t 0 -pc /etc/${DIREWOLF_CONF:-direwolf.conf}
