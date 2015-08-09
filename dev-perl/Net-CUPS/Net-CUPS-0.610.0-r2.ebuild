# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DHAGEMAN
MODULE_VERSION=0.61
inherit perl-module

DESCRIPTION="CUPS C API Interface"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="net-print/cups"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

PATCHES=( "${FILESDIR}/${P}-cups16.patch" )

SRC_TEST="do"
