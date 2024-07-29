# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for nvidia-persistenced"
ACCT_USER_ID=458
ACCT_USER_GROUPS=( video )

acct-user_add_deps
