# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=HAARG
MODULE_VERSION=0.400002
inherit perl-module

DESCRIPTION='Read and write Changes files'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Text-Tabs+Wrap-0.3.0
	>=virtual/perl-version-0.990.600
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.960.0 )
"

SRC_TEST="do parallel"
