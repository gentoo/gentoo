# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for snort"
ACCT_USER_ID=328
ACCT_USER_GROUPS=( snort )

acct-user_add_deps
