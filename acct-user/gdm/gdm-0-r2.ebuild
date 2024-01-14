# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for running GDM"
ACCT_USER_ID=32
ACCT_USER_GROUPS=( gdm video )
ACCT_USER_HOME=/var/lib/gdm

acct-user_add_deps
