# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ARISTOTLE
DIST_VERSION=0.60
inherit perl-module

DESCRIPTION="Fast, safe DBI connection and transaction management"

SLOT="0"
KEYWORDS="amd64"

RDEPEND=">=dev-perl/DBI-1.614.0"
