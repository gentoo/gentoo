# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for duende processmanager"
ACCT_USER_ID=66
ACCT_USER_GROUPS=( maradns )

acct-user_add_deps
