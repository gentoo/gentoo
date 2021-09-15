# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-dns/ez-ipupdate"

ACCT_USER_GROUPS=( "ez-ipupd" )
ACCT_USER_HOME="/var/cache/ez-ipupdate"
ACCT_USER_ID="261"

acct-user_add_deps
