# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for www-apps/karma-bin"

ACCT_USER_ID=118
ACCT_USER_GROUPS=( karma )

acct-user_add_deps
