# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for kube-apiserver"
ACCT_USER_ID=432
ACCT_USER_GROUPS=( kube-apiserver )

acct-user_add_deps
