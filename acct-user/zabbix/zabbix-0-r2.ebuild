# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for Zabbix"
ACCT_USER_ID=329
# see https://www.zabbix.com/documentation/current/manual/installation/install
ACCT_USER_HOME=/var/lib/${PN}
ACCT_USER_HOME_PERMS=770
ACCT_USER_GROUPS=( "${PN}" )

acct-user_add_deps
