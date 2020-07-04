# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MARKOV
DIST_VERSION=0.99
inherit perl-module

DESCRIPTION="XML::LibXML based XML::Simple clone"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Scalar-List-Utils
	>=dev-perl/XML-LibXML-1.640.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.540.0
	)
"
