# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for docker_auth"
ACCT_USER_ID=345
ACCT_USER_GROUPS=( docker_auth )

acct-user_add_deps
