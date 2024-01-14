# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="added by portage for motion, a software motion detector"
ACCT_USER_ID=395
ACCT_USER_GROUPS=( motion video )

acct-user_add_deps
