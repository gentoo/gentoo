# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SZABGAB
MODULE_VERSION=2.64
inherit perl-module

DESCRIPTION="Perl extension for generating Scalable Vector Graphics (SVG) documents"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-parent
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST="do parallel"
