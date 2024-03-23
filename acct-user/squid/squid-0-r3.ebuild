# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for squid web proxy cache"
ACCT_USER_ID=301
ACCT_USER_HOME=/var/cache/squid
ACCT_USER_GROUPS=( squid )

acct-user_add_deps
