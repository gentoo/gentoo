# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="A virtual MIDI keyboard for JACK MIDI"
HOMEPAGE="http://pin.if.uz.zgora.pl/~trasz/jack-keyboard/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lash X"

CDEPEND="
	dev-libs/glib:2
	virtual/jack
	x11-libs/gtk+:2
	lash? ( media-sound/lash )
	X? ( x11-libs/libX11 )
"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-man.patch"
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DJackEnable=ON # though configurable, does not compile withou jack
		-DLashEnable=$(usex lash)
		-DX11Enable=$(usex X)
	)

	cmake_src_configure
}
