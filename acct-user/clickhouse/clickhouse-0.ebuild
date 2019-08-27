# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="ClickHouse server user"
ACCT_USER_ID=449
ACCT_USER_HOME=/var/lib/clickhouse-server
ACCT_USER_HOME_PERMS=0750
ACCT_USER_GROUPS=( clickhouse )

acct-user_add_deps
