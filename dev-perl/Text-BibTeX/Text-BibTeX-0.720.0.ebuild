# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="AMBS"
MODULE_VERSION=0.72

inherit perl-module

DESCRIPTION="A Perl library for reading, parsing, and processing BibTeX files"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-perl/Config-AutoConf-0.16
	>=dev-perl/ExtUtils-LibBuilder-0.02
	>=virtual/perl-ExtUtils-CBuilder-0.27
	>=dev-perl/Module-Build-0.36.03"
RDEPEND="!dev-libs/btparse
	>=dev-perl/Capture-Tiny-0.06"

SRC_TEST="do"

src_prepare() {
	sed -i -e "/#include <stdio.h>/a #include <string.h>"\
		btparse/tests/{tex,purify,postprocess,name,macro}_test.c || die
	perl-module_src_prepare
}
