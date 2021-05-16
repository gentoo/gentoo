# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for bind_exporter"
ACCT_USER_ID=276
ACCT_USER_GROUPS=( bind_exporter )

acct-user_add_deps
