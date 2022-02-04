# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit acct-user

DESCRIPTION="A user for app-misc/rundeck-bin"

ACCT_USER_ID=109
ACCT_USER_HOME=/var/lib/rundeck
ACCT_USER_SHELL=/bin/bash
ACCT_USER_GROUPS=( rundeck )

acct-user_add_deps
