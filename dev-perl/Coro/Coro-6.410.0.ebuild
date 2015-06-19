# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Coro/Coro-6.410.0.ebuild,v 1.1 2014/12/18 20:49:19 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=6.41
inherit perl-module

DESCRIPTION="The only real threads in perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/AnyEvent-5
	>=dev-perl/Guard-0.500.0
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Storable-2.150.0
	dev-perl/common-sense
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"
