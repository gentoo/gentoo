# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-C3/Class-C3-0.280.0.ebuild,v 1.4 2015/05/27 21:10:18 zlogene Exp $

EAPI=5

MODULE_AUTHOR=HAARG
MODULE_VERSION=0.28
inherit perl-module

DESCRIPTION="A pragma to use the C3 method resolution order algortihm"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Algorithm-C3-0.70.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-CBuilder-0.270.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST=do
