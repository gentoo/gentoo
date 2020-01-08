# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for gnustep-apps/sogo"
ACCT_USER_ID=475
ACCT_USER_GROUPS=( sogo )
ACCT_USER_HOME="/var/lib/sogo"
ACCT_USER_SHELL=/bin/bash

acct-user_add_deps
