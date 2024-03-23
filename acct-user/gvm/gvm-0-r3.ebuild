# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Greenbone vulnerability management program user"
ACCT_USER_ID=495
ACCT_USER_HOME=/var/lib/gvm
ACCT_USER_GROUPS=( gvm )

acct-user_add_deps
