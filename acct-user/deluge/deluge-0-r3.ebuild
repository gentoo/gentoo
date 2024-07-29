# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for deluge"
ACCT_USER_ID=454
ACCT_USER_GROUPS=( deluge )
ACCT_USER_HOME=/var/lib/deluge

acct-user_add_deps
