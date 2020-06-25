# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="Metronome application supporting different meters and speeds ranging"
HOMEPAGE="https://www.antcom.de/gtick"
SRC_URI="https://www.antcom.de/gtick/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="nls sndfile"

RDEPEND="x11-libs/gtk+:2
	media-sound/pulseaudio
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )
	virtual/pkgconfig"

RESTRICT="test"

src_prepare() {
	default
	sed -i "/GenericName/d" ${PN}.desktop || die
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with sndfile)
}

src_install() {
	default
	newicon src/icon48x48.xpm ${PN}.xpm
	make_desktop_entry ${PN} "GTick"
}
