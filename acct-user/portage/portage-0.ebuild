# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=250
ACCT_USER_HOME="/var/lib/portage/home"
ACCT_USER_GROUPS=( portage )

acct-user_add_deps
