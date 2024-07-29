# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit acct-user

DESCRIPTION="A user for app-admin/fluentd"

ACCT_USER_ID=504
ACCT_USER_GROUPS=( fluentd )

acct-user_add_deps
