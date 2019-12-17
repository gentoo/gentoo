# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop xdg

DESCRIPTION="JACK client record button remembering the last 10 seconds when pressed"
HOMEPAGE="http://plugin.org.uk/timemachine/"
SRC_URI="https://github.com/swh/timemachine/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="lash"

BDEPEND="
	virtual/pkgconfig
"
CDEPEND="
	virtual/jack
	x11-libs/gtk+:2
	media-libs/liblo
	>=media-libs/libsndfile-1.0.5
	lash? ( >=media-sound/lash-0.5 )
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

PATCHES=( "${FILESDIR}/${P}-underlinking.patch" )

src_prepare() {
	mv configure.{in,ac} || die

	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable lash)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog NEWS README TODO
	newicon pixmaps/timemachine-icon.png "${PN}.png"

	make_desktop_entry timemachine "TimeMachine Recording" timemachine
}
