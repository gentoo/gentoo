# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="File Transfer Protocol server user"
ACCT_USER_ID=21
ACCT_USER_HOME=/home/ftp
ACCT_USER_HOME_OWNER=root:ftp
ACCT_USER_GROUPS=( ftp )

acct-user_add_deps
