# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="candido-engine-${PV}"

DESCRIPTION="Candido GTK+ 2.x Theme Engine"
HOMEPAGE="https://sourceforge.net/projects/candido.berlios/"
SRC_URI="mirror://sourceforge/candido.berlios/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${P}-glib-2.31.patch )

src_prepare() {
	default
	eautoreconf # required for interix
}

src_configure() {
	econf --enable-animation
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
