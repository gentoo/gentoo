# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit perl-module
SRC_URI="http://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.gz"

DESCRIPTION="Mozilla's CA cert bundle in PEM format (Gentoo stub)"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND="app-misc/ca-certificates"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
