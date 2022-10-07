# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit autotools wxwidgets

DESCRIPTION="A phylogenetic tree viewer"
HOMEPAGE="http://darwin.zoology.gla.ac.uk/~rpage/treeviewx/"
SRC_URI="http://darwin.zoology.gla.ac.uk/~rpage/${PN}/download/$(ver_cut 1-2)/tv-${PV}.tar.gz"
S="${WORKDIR}/tv-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-wxt.patch
	"${FILESDIR}"/${P}-gcc4.3.patch
	"${FILESDIR}"/${P}-70_choose_tree.patch
	"${FILESDIR}"/${P}-fix_loading_crash.patch
	"${FILESDIR}"/${P}-wx30.patch
	"${FILESDIR}"/${P}-svg.patch
	"${FILESDIR}"/${P}-treeview-xpm-not-xbm.patch
	"${FILESDIR}"/${P}-wxstring-maxlen.patch
	"${FILESDIR}"/${P}-AM_PROG_AR.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	setup-wxwidgets
	default
}
