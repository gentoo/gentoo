# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="FRITZ!Box Smart Home Exporter User"

ACCT_USER_ID=228
ACCT_USER_GROUPS=( ${PN} )

acct-user_add_deps
