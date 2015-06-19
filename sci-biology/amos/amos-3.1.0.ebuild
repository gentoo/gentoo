# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/amos/amos-3.1.0.ebuild,v 1.8 2013/03/19 07:41:20 jlec Exp $

EAPI=4

inherit eutils

DESCRIPTION="A Modular, Open-Source whole genome assembler"
HOMEPAGE="http://amos.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="qt4"

DEPEND="qt4? ( dev-qt/qtcore:4 )"
RDEPEND="${DEPEND}
	dev-perl/DBI
	dev-perl/Statistics-Descriptive
	sci-biology/mummer"

MAKEOPTS+=" -j1"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc-4.7.patch
}
