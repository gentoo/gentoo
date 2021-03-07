# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for kube-scheduler"
ACCT_USER_ID=434
ACCT_USER_GROUPS=( kube-scheduler )

acct-user_add_deps
