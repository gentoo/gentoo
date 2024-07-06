# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop xdg-utils

DESCRIPTION="Simple DVD slideshow maker"
HOMEPAGE="https://imagination.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/glib:2
	media-sound/sox:=
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango"
RDEPEND="${DEPEND}
	media-video/ffmpeg"
BDEPEND="dev-util/intltool"

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${PN}-3.0-fix-htmldir.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	doicon icons/48x48/${PN}.png

	# only plugins
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
