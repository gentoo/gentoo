# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user id for geneweb daemon"

ACCT_USER_ID=467
ACCT_USER_HOME=/var/lib/geneweb
ACCT_USER_GROUPS=( geneweb )

acct-user_add_deps
