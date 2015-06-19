# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/amos/amos-3.1.0-r1.ebuild,v 1.2 2015/04/08 18:20:42 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

DESCRIPTION="A Modular, Open-Source whole genome assembler"
HOMEPAGE="http://amos.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4"

DEPEND="qt4? ( dev-qt/qtcore:4 )"
RDEPEND="${DEPEND}
	dev-perl/DBI
	dev-perl/Statistics-Descriptive
	sci-biology/mummer"

MAKEOPTS+=" -j1"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc-4.7.patch \
		"${FILESDIR}"/${P}-goBambus2.py-indent-and-cleanup.patch
}

src_install() {
	default
	python_replicate_script "${ED}"/usr/bin/goBambus2
}
