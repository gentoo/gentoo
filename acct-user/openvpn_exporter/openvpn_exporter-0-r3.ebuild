# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for openvpn_exporter"
ACCT_USER_ID=355
ACCT_USER_GROUPS=( openvpn_exporter )
ACCT_USER_HOME=/var/lib/openvpn_exporter

acct-user_add_deps
