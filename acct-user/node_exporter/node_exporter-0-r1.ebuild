# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="node_exporter User"
ACCT_USER_ID=459
ACCT_USER_GROUPS=( node_exporter )

acct-user_add_deps
