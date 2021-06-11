# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-dialup/sendpage"

ACCT_USER_GROUPS=( "sms" )
ACCT_USER_ID="406"

acct-user_add_deps
