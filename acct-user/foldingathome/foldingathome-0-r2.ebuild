# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for sci-biology/foldingathome"

ACCT_USER_GROUPS=( "foldingathome" "video" )
ACCT_USER_HOME="/opt/foldingathome"
ACCT_USER_ID="128"

acct-user_add_deps
