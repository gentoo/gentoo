# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Mail program user"
ACCT_USER_ID=8
ACCT_USER_HOME=/var/spool/mail
ACCT_USER_HOME_OWNER=root:mail
ACCT_USER_HOME_PERMS=03775
ACCT_USER_GROUPS=( mail )

acct-user_add_deps
