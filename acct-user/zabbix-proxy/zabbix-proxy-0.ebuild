# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit acct-user

DESCRIPTION="ZABBIX monitoring user (proxy part)"

ACCT_USER_ID=171
ACCT_USER_HOME=/var/lib/zabbix-proxy
ACCT_USER_HOME_OWNER=root:zabbix
ACCT_USER_HOME_PERMS=750
ACCT_USER_SHELL=-1
ACCT_USER_GROUPS=( zabbix-proxy )

acct-user_add_deps
