# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit acct-user

DESCRIPTION="A user for app-metrics/snmp_exporter"

ACCT_USER_ID=108
ACCT_USER_GROUPS=( snmp_exporter )

acct-user_add_deps
