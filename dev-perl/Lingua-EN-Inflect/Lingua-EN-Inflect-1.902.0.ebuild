# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DCONWAY
DIST_VERSION=1.902
DIST_EXAMPLES=("demo/*")
inherit perl-module

DESCRIPTION="Perl module to pluralize English words"

SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 ~sparc x86"
IUSE="test"

DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
