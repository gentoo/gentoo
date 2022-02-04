# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="a fast web-interface for git repositories"

ACCT_USER_ID=197
ACCT_USER_GROUPS=( cgit )

acct-user_add_deps
