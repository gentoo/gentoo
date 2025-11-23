# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for influxdb"
ACCT_USER_ID=342
ACCT_USER_GROUPS=( influxdb )
ACCT_USER_HOME=/var/lib/influxdb

acct-user_add_deps
