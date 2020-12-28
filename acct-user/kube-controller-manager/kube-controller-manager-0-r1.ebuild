# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for kube-controller-manager"
ACCT_USER_ID=433
ACCT_USER_GROUPS=( kube-controller-manager )

acct-user_add_deps
