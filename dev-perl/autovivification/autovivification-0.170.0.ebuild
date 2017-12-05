# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=VPIT
DIST_VERSION=0.17
DIST_EXAMPLES=("samples/*")
inherit perl-module

DESCRIPTION="Lexically disable autovivification"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

RDEPEND="virtual/perl-XSLoader"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Exporter
		virtual/perl-Test-Simple
	)
"
