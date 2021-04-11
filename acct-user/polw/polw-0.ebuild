# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for mail-filter/policyd-weight"

ACCT_USER_GROUPS=( "polw" )
ACCT_USER_ID="263"

acct-user_add_deps
