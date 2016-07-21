# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TIMB
MODULE_VERSION=6.02
inherit perl-module

DESCRIPTION="Powerful feature-rich perl source code profiler"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/File-Which-1.90.0
	virtual/perl-Getopt-Long
	dev-perl/JSON-MaybeXS
	virtual/perl-Scalar-List-Utils
	virtual/perl-XSLoader
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Scalar-List-Utils
		>=virtual/perl-Test-Simple-0.840.0
		>=dev-perl/Test-Differences-0.60.0
	)
"

SRC_TEST="do"
