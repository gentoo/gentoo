# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Inline-Python/Inline-Python-0.490.0.ebuild,v 1.1 2015/07/04 12:40:08 dilfridge Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )
# Feel free to add more targets after testing.

MODULE_AUTHOR=NINE
MODULE_VERSION=0.49
inherit python-single-r1 perl-module

DESCRIPTION="Easy implementation of Python extensions"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Data-Dumper
	>=virtual/perl-Digest-MD5-2.500.0
	>=dev-perl/Inline-0.46
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		virtual/perl-Test
	)
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=( "${FILESDIR}/${PN}-0.460.0-insanepython.patch" )

SRC_TEST="do"
