# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the bareos network backup suite"
ACCT_USER_ID=403
ACCT_USER_HOME=/var/lib/${PN}
ACCT_USER_GROUPS=( ${PN} disk tape cdrom )

acct-user_add_deps
