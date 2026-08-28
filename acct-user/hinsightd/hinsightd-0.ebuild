# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user account for www-servers/hinsightd"
KEYWORDS="~amd64"

ACCT_USER_ID=368
ACCT_USER_GROUPS=( hinsightd )

acct-user_add_deps
