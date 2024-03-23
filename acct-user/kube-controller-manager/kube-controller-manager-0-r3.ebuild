# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for kube-controller-manager"
ACCT_USER_ID=433
ACCT_USER_GROUPS=( kube-controller-manager )

acct-user_add_deps
