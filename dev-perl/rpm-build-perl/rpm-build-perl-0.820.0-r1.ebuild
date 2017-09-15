# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ATOURBIN
DIST_VERSION=0.82
inherit perl-module

DESCRIPTION="Automatically extract Perl dependencies"
SRC_URI+=" https://dev.gentoo.org/~dilfridge/distfiles/${P}-perl526.patch.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Encode
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"

PATCHES=( "${WORKDIR}/${P}-perl526.patch" )

#DIST_TEST=skip
# one subtest fails, reason so far unknown
