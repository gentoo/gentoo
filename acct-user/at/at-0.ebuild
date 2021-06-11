# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for at daemon"
ACCT_USER_ID=246
ACCT_USER_GROUPS=( at )

acct-user_add_deps
