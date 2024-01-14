# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for www-apps/radicale"
ACCT_USER_ID=327
ACCT_USER_GROUPS=( radicale )
ACCT_USER_HOME=/var/lib/radicale

acct-user_add_deps
