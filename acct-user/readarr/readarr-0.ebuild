# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for readarr"
ACCT_USER_HOME=/var/lib/readarr
ACCT_USER_ID=521
ACCT_USER_GROUPS=( readarr )

acct-user_add_deps
