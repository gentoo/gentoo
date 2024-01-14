# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for media-gfx/sane-backends"

ACCT_USER_GROUPS=( "scanner" )
ACCT_USER_ID="409"

acct-user_add_deps
