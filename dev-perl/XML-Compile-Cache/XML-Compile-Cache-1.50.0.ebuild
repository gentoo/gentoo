# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MARKOV
DIST_VERSION=1.05
inherit perl-module

DESCRIPTION="Cache compiled XML translations"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Log-Report-0.190.0
	>=dev-perl/XML-Compile-1.480.0
	>=dev-perl/XML-LibXML-Simple-0.950.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.540.0
		>=dev-perl/XML-Compile-Tester-0.20.0
	)
"
