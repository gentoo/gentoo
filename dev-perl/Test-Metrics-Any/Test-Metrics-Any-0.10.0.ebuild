# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.01
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Assert that code produces metrics via Metrics::Any"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Metrics-Any
"
BDEPEND="
	dev-perl/Module-Build
"
