# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop xdg

DESCRIPTION="Streaming GTK+ Front-End based on Darkice Ice Streamer"
HOMEPAGE="https://darksnow.radiolivre.org"
SRC_URI="https://darksnow.radiolivre.org/pacotes/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

PDEPEND=">=media-sound/darkice-1.2"
RDEPEND=">=x11-libs/gtk+-2.14.0:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default
	dodoc documentation/{CHANGES,CREDITS,README*}

	make_desktop_entry ${PN} "DarkSnow" ${PN}
}
