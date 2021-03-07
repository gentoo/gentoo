# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for running GDM"
ACCT_USER_ID=32
ACCT_USER_GROUPS=( gdm video )
ACCT_USER_HOME=/var/lib/gdm

acct-user_add_deps
