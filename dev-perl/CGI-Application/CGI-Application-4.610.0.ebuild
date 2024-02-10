# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MARTO
DIST_VERSION=4.61
inherit perl-module

DESCRIPTION="Framework for building reusable web-applications"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="minimal test"
RESTRICT="!test? ( test )"
RDEPEND="
	!minimal? (
		>=dev-perl/CGI-PSGI-0.90.0
	)
	>=dev-perl/CGI-4.210.0
	virtual/perl-Carp
	dev-perl/Class-ISA
	dev-perl/HTML-Template
	virtual/perl-Scalar-List-Utils
	virtual/perl-libnet
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.470.0
	)
"
