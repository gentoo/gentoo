# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR="KRYDE"
DIST_VERSION="122"
inherit perl-module

DESCRIPTION="Mathematical paths through the 2-D plane"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gmp test examples"

RDEPEND="gmp? ( dev-perl/Math-BigInt-GMP )
	dev-perl/Math-Libm
	dev-perl/Math-NumSeq
	>=dev-perl/constant-defer-5.0.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-Math-BigInt"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test
		dev-perl/Math-BigInt-Lite
		dev-perl/Number-Fraction )"

src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
