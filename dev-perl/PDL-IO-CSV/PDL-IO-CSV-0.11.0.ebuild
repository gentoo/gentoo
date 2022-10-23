# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KMX
DIST_VERSION=0.011

inherit perl-module

DESCRIPTION="Load/save PDL from/to CSV file (optimized for speed and large data)"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	>=dev-perl/PDL-2.6.0
	dev-perl/Text-CSV_XS
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/Test-Number-Delta-1.60.0
	)
"
