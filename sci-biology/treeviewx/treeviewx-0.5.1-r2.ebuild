# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

WX_GTK_VER="2.8"
inherit eutils wxwidgets

DESCRIPTION="A phylogenetic tree viewer"
HOMEPAGE="http://darwin.zoology.gla.ac.uk/~rpage/treeviewx/"
SRC_URI="http://darwin.zoology.gla.ac.uk/~rpage/${PN}/download/0.5/tv-${PV}.tar.gz"
LICENSE="GPL-2"

KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

DEPEND="x11-libs/wxGTK:2.8[X]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/tv-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-wxt.patch
	epatch "${FILESDIR}"/${P}-gcc4.3.patch
	epatch "${FILESDIR}"/${P}-wx28.patch
}

src_install() {
	emake install DESTDIR="${D}" || die "make install failed"
}
