# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="grafana program user"

ACCT_USER_ID=389
ACCT_USER_GROUPS=( ${PN} )

acct-user_add_deps
