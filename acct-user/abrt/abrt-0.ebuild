# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the automatic bug detection and reporting tool"
ACCT_USER_ID=422
ACCT_USER_GROUPS=( abrt )

acct-user_add_deps
