# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.011
inherit perl-module

DESCRIPTION="Ensure Changes has content before releasing"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Data-Section-0.200.2
	>=dev-perl/Dist-Zilla-6.0.0
	>=dev-perl/Moose-2.0.0
	dev-perl/Sub-Exporter-ForMethods
	>=virtual/perl-autodie-2.0.0
	>=dev-perl/namespace-autoclean-0.280.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		dev-perl/Capture-Tiny
		dev-perl/Path-Tiny
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
	)
"
