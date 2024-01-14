# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_GROUPS=( gatling )
ACCT_USER_HOME=/var/www/localhost
ACCT_USER_ID=364  # matches acct-group/gatling

acct-user_add_deps
