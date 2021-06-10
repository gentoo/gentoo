# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

DESCRIPTION="wavbreaker/wavmerge GTK+ utility to break or merge WAV files"
HOMEPAGE="http://wavbreaker.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="mp3"

RDEPEND="
	dev-libs/glib
	media-libs/libao
	x11-libs/gtk+:3
	mp3? ( media-sound/mpg123 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.13-QA-desktop-file.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use mp3)
	)

	meson_src_configure
}
