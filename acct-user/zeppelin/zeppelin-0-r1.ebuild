# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for system-wide www-apps/zeppelin-bin"
ACCT_USER_ID=224
ACCT_USER_GROUPS=( "${PN}" )
ACCT_USER_HOME=/home/zeppelin
ACCT_USER_SHELL=/bin/sh

acct-user_add_deps
