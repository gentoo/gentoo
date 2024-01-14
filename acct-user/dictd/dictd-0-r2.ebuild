# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="uid for app-text/dictd"
ACCT_USER_ID=381
ACCT_USER_GROUPS=( dictd )

acct-user_add_deps
