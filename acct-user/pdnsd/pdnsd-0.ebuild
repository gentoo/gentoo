# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for pdns daemon"
ACCT_USER_ID=184
ACCT_USER_HOME=/var/lib/pdnsd
ACCT_USER_HOME_OWNER=pdnsd:root
ACCT_USER_GROUPS=( pdnsd )

acct-user_add_deps
