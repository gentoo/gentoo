# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=525
ACCT_USER_HOME=/var/lib/knot-resolver
ACCT_USER_GROUPS=( knot-resolver )

acct-user_add_deps
