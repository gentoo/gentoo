# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for running the GeoClue D-Bus geolocation service"
ACCT_USER_ID=351
ACCT_USER_GROUPS=( geoclue )
ACCT_USER_HOME=/var/lib/geoclue

acct-user_add_deps
