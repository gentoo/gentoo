# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SALVA
DIST_VERSION=0.22
inherit perl-module

DESCRIPTION="Manipulate 128 bits integers in Perl"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/Math-Int64"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"
