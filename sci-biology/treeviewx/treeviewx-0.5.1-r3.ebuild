# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER=3.0

inherit autotools eutils wxwidgets

DESCRIPTION="A phylogenetic tree viewer"
HOMEPAGE="http://darwin.zoology.gla.ac.uk/~rpage/treeviewx/"
SRC_URI="http://darwin.zoology.gla.ac.uk/~rpage/${PN}/download/0.5/tv-${PV}.tar.gz"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/tv-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-wxt.patch
	"${FILESDIR}"/${P}-gcc4.3.patch
	"${FILESDIR}"/${P}-70_choose_tree.patch
	"${FILESDIR}"/${P}-fix_loading_crash.patch
	"${FILESDIR}"/${P}-wx30.patch
	"${FILESDIR}"/${P}-svg.patch
	"${FILESDIR}"/${P}-treeview-xpm-not-xbm.patch
	"${FILESDIR}"/${P}-wxstring-maxlen.patch
	)

src_prepare() {
	epatch "${PATCHES[@]}"
	mv configure.{in,ac} || die
	eautoreconf
}
