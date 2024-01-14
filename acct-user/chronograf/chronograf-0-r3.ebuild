# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for chronograf"
ACCT_USER_ID=344
ACCT_USER_GROUPS=( chronograf )
ACCT_USER_HOME=/var/lib/chronograf

acct-user_add_deps
