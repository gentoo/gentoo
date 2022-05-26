# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for various jabber services"

ACCT_USER_GROUPS=( "jabber" )
ACCT_USER_ID="379"

acct-user_add_deps
