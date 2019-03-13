# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=1.000008
inherit perl-module

DESCRIPTION="Call isa, can, does and DOES safely on things that may not be objects"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
