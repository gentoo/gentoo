# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for running sobby"
ACCT_USER_ID=322
ACCT_USER_GROUPS=( sobby )
ACCT_USER_HOME=/var/lib/sobby
ACCT_USER_HOME_PERMS=0700

acct-user_add_deps
