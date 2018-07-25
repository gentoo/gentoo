# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop gnome2-utils

DESCRIPTION="Networked multiplayer-only Puzzle Bubble clone"
HOMEPAGE="http://freshmeat.net/projects/pengupop"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eapply "${FILESDIR}"/${P}-underlink.patch

	sed -i \
		-e '/Icon/s/\.png//' \
		-e '/^Encoding/d' \
		-e '/Categories/s/Application;//' \
		pengupop.desktop || die

	sed -i \
		-e 's/-g -Wall -O2/-Wall/' \
		Makefile.am || die

	mv configure.in configure.ac || die
	eautoreconf
}

src_install() {
	default
	domenu pengupop.desktop
	doicon -s 48 pengupop.png
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
