# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop gnome2-utils scons-utils

DESCRIPTION="Real Time Strategy (RTS) game involving a brave army of globs"
HOMEPAGE="http://globulation2.org/"
SRC_URI="mirror://nongnu/glob2/${PV:0:5}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/boost-1.34[threads]
	dev-libs/fribidi
	media-libs/libsdl[opengl]
	media-libs/libvorbis
	media-libs/sdl-image[png]
	media-libs/sdl-net
	media-libs/sdl-ttf
	media-libs/speex
	virtual/glu
	virtual/opengl
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-{gcc{44,49,6},scons-blows,underlinking}.patch )

src_configure() {
	myesconsargs=(
		INSTALLDIR=/usr/share/${PN}
		DATADIR=/usr/share/${PN}
	)
	escons data
}

src_compile() {
	escons
}

src_install() {
	dobin src/${PN}
	insinto /usr/share/${PN}
	doins -r campaigns data maps scripts
	find "${ED}"/usr/share/${PN} -name SConscript -exec rm -f '{}' +
	newicon -s 48 data/icons/glob2-icon-48x48.png ${PN}.png
	make_desktop_entry glob2 "Globulation 2"
	einstalldocs
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
