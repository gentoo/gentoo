# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_/-}"
inherit autotools desktop

DESCRIPTION="A Midi Controllable Audio Sampler"
HOMEPAGE="http://zhevny.com/specimen"
SRC_URI="http://zhevny.com/${PN}/files/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE="lash"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-libs/libxml2:2
	gnome-base/libgnomecanvas
	>=media-libs/alsa-lib-0.9
	media-libs/libsamplerate
	media-libs/libsndfile
	>=media-libs/phat-0.4
	>=media-sound/jack-audio-connection-kit-0.109.2
	x11-libs/gtk+:2
	lash? ( media-sound/lash )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-jackmidi.patch"
	"${FILESDIR}/${P}-underlinking.patch"
)

S="${WORKDIR}"/${PN}-${MY_PV}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable lash)
}

src_install() {
	default
	doicon pixmaps/${PN}.png
	make_desktop_entry ${PN} Specimen ${PN}
}
