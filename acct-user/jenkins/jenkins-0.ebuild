# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Jenkins program user"
ACCT_USER_ID=473
ACCT_USER_HOME=/var/lib/jenkins
ACCT_USER_HOME_PERMS=0750
ACCT_USER_GROUPS=( jenkins )
acct-user_add_deps
