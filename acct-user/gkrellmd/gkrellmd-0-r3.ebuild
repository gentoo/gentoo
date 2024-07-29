# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for gkrellm daemon"
ACCT_USER_ID=221
ACCT_USER_GROUPS=( gkrellmd )

acct-user_add_deps
