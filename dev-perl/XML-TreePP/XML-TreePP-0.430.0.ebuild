# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_VERSION=0.43
MODULE_AUTHOR="KAWASAKI"
inherit perl-module

DESCRIPTION="Pure Perl implementation for parsing/writing XML documents"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

#	test? ( dev-perl/Jcode
#		dev-perl/libwww-perl )"
# tests need network
SRC_TEST=skip
