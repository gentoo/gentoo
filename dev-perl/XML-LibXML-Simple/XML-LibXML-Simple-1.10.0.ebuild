# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="XML::LibXML based XML::Simple clone"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~riscv ~x86"

RDEPEND="
	virtual/perl-Scalar-List-Utils
	>=dev-perl/XML-LibXML-1.640.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.540.0
	)
"
