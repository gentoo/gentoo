# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User used to run distcc daemon"
ACCT_USER_ID=240
ACCT_USER_GROUPS=( distcc )

acct-user_add_deps
