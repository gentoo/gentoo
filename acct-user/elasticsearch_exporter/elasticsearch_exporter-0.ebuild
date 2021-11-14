# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit acct-user

DESCRIPTION="A user for app-metrics/elasticsearch_exporter"

ACCT_USER_ID=98
ACCT_USER_GROUPS=( elasticsearch_exporter )

acct-user_add_deps
