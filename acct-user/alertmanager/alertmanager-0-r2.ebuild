# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for alertmanager"
ACCT_USER_ID=294
ACCT_USER_GROUPS=( alertmanager )

acct-user_add_deps
