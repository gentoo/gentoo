# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for sci-mathematics/rstudio"
ACCT_USER_ID=466
ACCT_USER_GROUPS=( rstudio-server )

acct-user_add_deps
