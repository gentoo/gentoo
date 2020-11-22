# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=219
ACCT_USER_GROUPS=( sddm video )
ACCT_USER_HOME="/var/lib/sddm"

acct-user_add_deps
