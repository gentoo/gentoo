# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for media-gfx/sane-backends"

ACCT_USER_GROUPS=( "scanner" )
ACCT_USER_ID="409"

acct-user_add_deps
