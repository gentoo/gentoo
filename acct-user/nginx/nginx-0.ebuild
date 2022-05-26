# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID="82"
ACCT_USER_GROUPS=( "nginx" )
ACCT_USER_HOME="/var/lib/nginx"

acct-user_add_deps
