# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=77
ACCT_USER_GROUPS=( qemu kvm )

acct-user_add_deps
