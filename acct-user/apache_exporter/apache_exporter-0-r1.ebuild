# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the apache_exporter prometheus plugin"
KEYWORDS="~amd64 ~x86"

ACCT_USER_ID=-1
ACCT_USER_GROUPS=( apache_exporter )

acct-user_add_deps
