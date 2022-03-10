# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.234
inherit perl-module

DESCRIPTION="build sprintf-like functions of your own"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-perl/Params-Util
	dev-perl/Sub-Exporter
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
