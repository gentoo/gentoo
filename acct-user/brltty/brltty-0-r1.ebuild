# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for brltty"
ACCT_USER_ID=506
ACCT_USER_HOME=/var/lib/brltty
ACCT_USER_GROUPS=( brltty audio brlapi dialout input pulse-access root tty )

acct-user_add_deps
