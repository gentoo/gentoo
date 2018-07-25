# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MOTEMEN
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Compare JSON with Test::Deep"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Exporter-Lite
	dev-perl/JSON
	dev-perl/Test-Deep
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=dev-perl/Module-Build-Tiny-0.35.0
	test? (
		>=virtual/perl-Test-Simple-1.1.10
	)
"
