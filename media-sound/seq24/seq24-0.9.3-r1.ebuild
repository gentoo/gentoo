# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="Loop based MIDI sequencer with focus on live performances"
HOMEPAGE="https://edge.launchpad.net/seq24/"
SRC_URI="https://edge.launchpad.net/seq24/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="jack lash"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-cpp/gtkmm:2.4
	dev-libs/libsigc++:2
	media-libs/alsa-lib
	jack? ( virtual/jack )
	lash? ( media-sound/lash )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README RTC SEQ24 )

PATCHES=( "${FILESDIR}/${P}-std-mutex.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable jack) \
		$(use_enable lash)
}

src_install() {
	default
	newicon src/pixmaps/seq24_32.xpm seq24.xpm
	make_desktop_entry seq24
}
