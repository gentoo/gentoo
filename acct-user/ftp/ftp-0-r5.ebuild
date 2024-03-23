# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="File Transfer Protocol (FTP) server user"

ACCT_USER_GROUPS=( "ftp" )
ACCT_USER_HOME="/var/lib/ftp"
ACCT_USER_HOME_OWNER="root:ftp"
ACCT_USER_ID="21"

acct-user_add_deps
