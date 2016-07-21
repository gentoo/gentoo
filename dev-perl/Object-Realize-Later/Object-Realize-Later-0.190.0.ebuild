# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MARKOV
MODULE_VERSION=0.19
inherit perl-module

DESCRIPTION="Delayed creation of objects"

SLOT="0"
KEYWORDS="~alpha amd64 x86"
IUSE="test"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Pod-1.0.0
	)
"

SRC_TEST=do
