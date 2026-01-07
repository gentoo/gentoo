# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="candido-engine-${PV}"

DESCRIPTION="Candido GTK+ 2.x Theme Engine"
HOMEPAGE="https://sourceforge.net/projects/candido.berlios/"
SRC_URI="https://downloads.sourceforge.net/candido.berlios/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-glib-2.31.patch
	"${FILESDIR}"/${P}-libm.patch
)

src_prepare() {
	default
	eautoreconf # update stale libtool
}

src_configure() {
	econf --enable-animation
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
