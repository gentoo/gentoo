# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKF
DIST_VERSION=2.04
inherit perl-module

DESCRIPTION="Simple database tests"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-perl/DBI"
BDEPEND="dev-perl/Module-Install"
