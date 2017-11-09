# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=RJBS
DIST_VERSION=0.200006
inherit perl-module

DESCRIPTION="read multiple hunks of data out of your DATA section"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# r: strict, warnings -> perl
RDEPEND="
	virtual/perl-Encode
	>=dev-perl/MRO-Compat-0.90.0
	>=dev-perl/Sub-Exporter-0.979.0
"
# t: base, lib, utf8 -> perl
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/Test-FailWarnings
		>=virtual/perl-Test-Simple-0.960.0
	)
"
