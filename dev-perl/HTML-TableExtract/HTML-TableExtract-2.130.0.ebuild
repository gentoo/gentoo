# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MSISK
MODULE_VERSION=2.13
inherit perl-module

DESCRIPTION="The Perl Table-Extract Module"

SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 x86 ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-perl/HTML-Element-Extended-1.160.0
	dev-perl/HTML-Parser
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

mydoc="TODO"

SRC_TEST="do parallel"
