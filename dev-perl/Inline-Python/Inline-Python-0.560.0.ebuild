# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
# Feel free to add more targets after testing.

DIST_AUTHOR=NINE
DIST_VERSION=0.56
inherit python-single-r1 perl-module

DESCRIPTION="Easy implementation of Python extensions"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Data-Dumper
	>=virtual/perl-Digest-MD5-2.500.0
	>=dev-perl/Inline-0.460.0
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Proc-ProcessTable-0.530.0
		virtual/perl-Test-Simple
		dev-perl/Test-Deep
		dev-perl/Test-Number-Delta
		virtual/perl-Test
	)
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=( "${FILESDIR}/${PN}-0.460.0-insanepython.patch" )
