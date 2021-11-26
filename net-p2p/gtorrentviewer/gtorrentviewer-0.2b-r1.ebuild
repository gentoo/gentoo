# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GNOME2_EAUTORECONF="yes"

inherit gnome2

MY_PN="GTorrentViewer"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A GTK2-based viewer and editor for BitTorrent meta files"
HOMEPAGE="http://gtorrentviewer.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

S="${WORKDIR}"/${MY_P}

RDEPEND="
	net-misc/curl
	>=x11-libs/gtk+-2.4:2
	>=dev-libs/glib-2.4:2
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-curl-headers.patch
	"${FILESDIR}"/${P}-underlinking.patch
	"${FILESDIR}"/${P}-desktop.patch
)

src_prepare() {
	# Bug #426262
	mv configure.in configure.ac || die

	# Fix tests
	echo "data/gtorrentviewer.desktop.in" >> po/POTFILES.in || die

	gnome2_src_prepare
}
