# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="Visual flashcard tool for memorizing the Japanese Hiragana and Katakana alphabet"
HOMEPAGE="https://www.clayo.org/kanatest"
SRC_URI="https://www.clayo.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="
	x11-libs/gtk+:2
	dev-libs/libxml2:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}+gtk-2.22.patch
	"${FILESDIR}"/${P}-autoconf.patch
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-desktop-QA.patch
	"${FILESDIR}"/${P}-format-security.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc TRANSLATORS
}
