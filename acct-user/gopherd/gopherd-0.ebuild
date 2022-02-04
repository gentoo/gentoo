# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for net-misc/geomyidae"

ACCT_USER_GROUPS=( "gopherd" )
ACCT_USER_HOME="/var/gopher"
ACCT_USER_ID="132"

acct-user_add_deps
