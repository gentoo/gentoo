# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="wavbreaker/wavmerge GTK+ utility to break or merge WAV files"
HOMEPAGE="https://wavbreaker.sourceforge.io/ https://github.com/thp/wavbreaker"
SRC_URI="https://github.com/thp/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mp3"

RDEPEND="
	dev-libs/glib
	media-libs/libao
	x11-libs/gtk+:3
	mp3? ( media-sound/mpg123 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		$(meson_use mp3)
	)

	meson_src_configure
}
