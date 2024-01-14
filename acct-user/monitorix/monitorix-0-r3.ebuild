# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Monitorix system tool user"
ACCT_USER_ID=401
ACCT_USER_GROUPS=( monitorix )

acct-user_add_deps
