# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit acct-user

DESCRIPTION="user for vinyl-cache"
ACCT_USER_ID=558
ACCT_USER_GROUPS=( vinyl )
ACCT_USER_HOME=/var/lib/vinyl-cache
ACCT_USER_HOME_PERMS=0750

acct-user_add_deps
