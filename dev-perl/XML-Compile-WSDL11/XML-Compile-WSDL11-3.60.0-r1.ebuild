# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MARKOV
DIST_VERSION=3.06
DIST_EXAMPLES=("bin/*")
inherit perl-module

DESCRIPTION="WSDL version 1.1 XML Compiler"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Log-Report-1.50.0
	>=dev-perl/XML-Compile-1.480.0
	>=dev-perl/XML-Compile-Cache-1.30.0
	>=dev-perl/XML-Compile-SOAP-3.160.0
"

# bug 774777
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Deep
		dev-perl/XML-Compile-Tester
		>=virtual/perl-Test-Simple-0.540.0
	)
"
