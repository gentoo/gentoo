# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for nsd daemon"
ACCT_USER_ID=223
ACCT_USER_GROUPS=( nsd )

acct-user_add_deps
