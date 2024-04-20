# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for ssh"

ACCT_USER_ID=22
ACCT_USER_HOME=/var/empty
ACCT_USER_HOME_OWNER=root:root
ACCT_USER_GROUPS=( sshd )

acct-user_add_deps
