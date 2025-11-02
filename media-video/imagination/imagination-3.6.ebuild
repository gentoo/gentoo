# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop xdg-utils

DESCRIPTION="Simple DVD slideshow maker"
HOMEPAGE="https://imagination.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# <sox-14.5: type mismatches with new sox_ng
DEPEND="
	dev-libs/glib:2
	<media-sound/sox-14.5:=
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango"
RDEPEND="${DEPEND}
	media-video/ffmpeg"
BDEPEND="dev-util/intltool"

# restricting tests as they're no practical tests
# to run ayway, see bug #935691
RESTRICT="test"

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
