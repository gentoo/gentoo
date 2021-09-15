# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MOTEMEN
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Compare JSON with Test::Deep"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Exporter-Lite
	dev-perl/JSON-MaybeXS
	dev-perl/Test-Deep
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=dev-perl/Module-Build-Tiny-0.35.0
	test? (
		>=virtual/perl-Test-Simple-1.1.10
	)
"
