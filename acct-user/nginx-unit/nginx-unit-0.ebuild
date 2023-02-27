# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID="526"
ACCT_USER_GROUPS=( "nginx-unit" )
ACCT_USER_HOME="/var/lib/nginx-unit"

acct-user_add_deps
