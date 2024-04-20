# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Trusted Software Stack for TPMs user"
ACCT_USER_ID=59
ACCT_USER_GROUPS=( tss )

acct-user_add_deps
