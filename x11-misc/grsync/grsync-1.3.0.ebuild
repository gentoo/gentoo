# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools xdg

DESCRIPTION="A gtk frontend to rsync"
HOMEPAGE="http://www.opbyte.it/grsync/"
SRC_URI="http://www.opbyte.it/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="+gtk3"

DEPEND="
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( >=x11-libs/gtk+-2.16:2 )"
RDEPEND="${DEPEND}
	net-misc/rsync"
BDEPEND="virtual/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS NEWS README"

PATCHES=( "${FILESDIR}"/${P}-desktop.patch
	"${FILESDIR}"/${P}-nested_func.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-unity $(use_enable gtk3)
}
