# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for chrooted scponly"
ACCT_USER_ID=239
ACCT_USER_GROUPS=( scponly )

acct-user_add_deps
