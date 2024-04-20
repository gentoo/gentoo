# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for netdata"
ACCT_USER_ID=290
ACCT_USER_GROUPS=( netdata )
ACCT_USER_HOME=/var/empty

acct-user_add_deps
