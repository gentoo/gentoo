# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Math-NumberCruncher/Math-NumberCruncher-5.0.0.ebuild,v 1.1 2014/10/21 23:20:28 dilfridge Exp $

EAPI=5

MODULE_VERSION=5.00
MODULE_AUTHOR=SIFUKURT
inherit perl-module

DESCRIPTION="Collection of useful math-related functions"
LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="
	>=virtual/perl-Math-BigInt-1.470.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
