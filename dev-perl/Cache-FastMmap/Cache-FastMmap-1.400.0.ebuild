# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Cache-FastMmap/Cache-FastMmap-1.400.0.ebuild,v 1.1 2014/10/26 22:24:08 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=ROBM
MODULE_VERSION=1.40
inherit perl-module

DESCRIPTION='Uses an mmaped file to act as a shared memory interprocess cache'
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
RDEPEND="${DEPEND}
	virtual/perl-Storable
"

SRC_TEST="do"
