# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for mongodb_exporter"
ACCT_USER_ID=277
ACCT_USER_GROUPS=( mongodb_exporter )

acct-user_add_deps
