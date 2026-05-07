# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="XAICRON"
DIST_VERSION="0.10"
inherit perl-module

DESCRIPTION="Simple mock test library using RAII"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
		>=dev-lang/perl-5.08.1
		>=dev-perl/Class-Load-0.06
		>=virtual/perl-Exporter-5.630
"
DEPEND="${RDEPEND}"
BDEPEND="
		dev-perl/Module-Build
"
