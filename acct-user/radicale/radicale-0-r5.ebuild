# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit acct-user

DESCRIPTION="User for www-apps/radicale"
ACCT_USER_ID=327
ACCT_USER_GROUPS=( radicale )
ACCT_USER_HOME=/var/lib/radicale
ACCT_USER_HOME_PERMS=0750

acct-user_add_deps
