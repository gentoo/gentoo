# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Redmine application user"
ACCT_USER_ID=451
ACCT_USER_GROUPS=( redmine )
acct-user_add_deps
