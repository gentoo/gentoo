# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PODMASTER
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Simplified interface to XML::Parser"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/XML-Parser-2.0.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
