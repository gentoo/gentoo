# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="PHAT is a collection of GTK+ widgets geared toward pro-audio apps"
HOMEPAGE="https://sourceforge.net/projects/phat.berlios/"
SRC_URI="mirror://sourceforge/phat.berlios/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="debug"

RDEPEND="gnome-base/libgnomecanvas
	x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/gtk-doc
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-underlinking.patch"
	"${FILESDIR}/${P}-libm-underlinking.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
