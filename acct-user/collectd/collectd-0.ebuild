# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="collectd program user"

ACCT_USER_ID=440
ACCT_USER_HOME="/var/lib/${PN}"
ACCT_USER_GROUPS=( ${PN} )

acct-user_add_deps
