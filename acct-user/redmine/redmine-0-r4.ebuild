# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Redmine application user"
ACCT_USER_ID=451
ACCT_USER_HOME=/var/lib/redmine
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( redmine )
acct-user_add_deps
