# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for www-servers/monkeyd"

ACCT_USER_GROUPS=( "monkeyd" )
ACCT_USER_HOME="/var/tmp/monkeyd"
ACCT_USER_HOME_PERMS="0770"
ACCT_USER_ID="149"

acct-user_add_deps
