# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="ADAMK"
MODULE_VERSION="1.04"

inherit perl-module

DESCRIPTION="A date object, with as little code as possible"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
SRC_TEST=do
# https://rt.cpan.org/Public/Bug/Display.html?id=108636
PATCHES=( "${FILESDIR}/${MODULE_VERSION}-locale-c.patch" )
DEPEND="virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )"
