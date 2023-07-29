# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.200008
inherit perl-module

DESCRIPTION="Read multiple hunks of data out of your DATA section"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	virtual/perl-Encode
	>=dev-perl/MRO-Compat-0.90.0
	>=dev-perl/Sub-Exporter-0.979.0
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		dev-perl/Test-FailWarnings
		>=virtual/perl-Test-Simple-0.960.0
	)
"
