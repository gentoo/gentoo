# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for app-metrics/redis_exporter"

ACCT_USER_HOME=/var/lib/redis_exporter
ACCT_USER_GROUPS=( "redis_exporter" )
ACCT_USER_ID="298"

acct-user_add_deps
