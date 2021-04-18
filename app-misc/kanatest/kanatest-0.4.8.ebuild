# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools epatch gnome2-utils

DESCRIPTION="Visual flashcard tool for memorizing the Japanese Hiragana and Katakana alphabet"
HOMEPAGE="http://www.clayo.org/kanatest"
SRC_URI="http://www.clayo.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND=">=x11-libs/gtk+-2.12:2=
	dev-libs/libxml2:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS TRANSLATORS ChangeLog README )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}+gtk-2.22.patch \
		"${FILESDIR}"/${P}-autoconf.patch \
		"${FILESDIR}"/${P}-cflags.patch

	sed -i \
		-e '/Encoding/d' \
		-e '/^Categories/s:Application;::' \
		-e '/^Icon/s:.png::' \
		data/${PN}.desktop || die

	eautoreconf
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
