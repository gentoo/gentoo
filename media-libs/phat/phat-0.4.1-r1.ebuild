# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="PHAT is a collection of GTK+ widgets geared toward pro-audio apps"
HOMEPAGE="https://sourceforge.net/projects/phat.berlios/"
SRC_URI="mirror://sourceforge/phat.berlios/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE="debug"

RDEPEND="x11-libs/gtk+:2
	x11-libs/libX11
	gnome-base/libgnomecanvas"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/gtk-doc"

PATCHES=(
	"${FILESDIR}/${P}-underlinking.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable debug)
}

src_install() {
	default
	prune_libtool_files --all
}
