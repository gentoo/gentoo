# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for net-ftp/frox"

ACCT_USER_GROUPS=( "ftpproxy" )
ACCT_USER_HOME="/var/spool/frox"
ACCT_USER_HOME_PERMS="700"
ACCT_USER_ID="182"

acct-user_add_deps
