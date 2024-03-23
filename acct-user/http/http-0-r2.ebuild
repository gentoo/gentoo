# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for www-servers/caddy"

ACCT_USER_HOME=/var/lib/http
ACCT_USER_GROUPS=( "http" )
ACCT_USER_ID="297"

acct-user_add_deps
