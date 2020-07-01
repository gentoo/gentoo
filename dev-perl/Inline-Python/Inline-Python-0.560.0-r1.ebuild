# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 python3_8 )
# Feel free to add more targets after testing.

DIST_AUTHOR=NINE
DIST_VERSION=0.56
inherit python-single-r1 perl-module

DESCRIPTION="Easy implementation of Python extensions"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Data-Dumper
	>=virtual/perl-Digest-MD5-2.500.0
	>=dev-perl/Inline-0.460.0
	${PYTHON_DEPS}
"
DEPEND="${PYTHON_DEPS}"
BDEPEND="${RDEPEND}
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
