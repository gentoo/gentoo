# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for app-containers/docker-registry"

ACCT_USER_GROUPS=( "registry" )
ACCT_USER_ID="295"

acct-user_add_deps
