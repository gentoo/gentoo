# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for stunnel"
ACCT_USER_ID=341
ACCT_USER_GROUPS=( stunnel )

acct-user_add_deps
