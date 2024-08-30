# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="Simple DVD slideshow maker"
HOMEPAGE="https://imagination.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-sound/sox:=
	x11-libs/cairo:=
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}
	media-video/ffmpeg"

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-enable-translations.patch
	"${FILESDIR}"/${P}-fix-htmldir.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default
	doicon icons/48x48/${PN}.png

	# only plugins
	find "${D}" -name '*.la' -delete || die
}
