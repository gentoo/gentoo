# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for running the colord service"
ACCT_USER_ID=350
ACCT_USER_GROUPS=( colord )
ACCT_USER_HOME=/var/lib/colord

acct-user_add_deps
