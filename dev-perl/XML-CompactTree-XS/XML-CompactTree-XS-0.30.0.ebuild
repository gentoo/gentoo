# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHOROBA
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="a fast builder of compact tree structures from XML documents"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-perl/XML-LibXML-1.690.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=("t/boilerplate.t" "t/pod-coverage.t" "t/pod.t")
