# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for dnsmasq_exporter"
ACCT_USER_ID=274
ACCT_USER_GROUPS=( dnsmasq_exporter )

acct-user_add_deps
