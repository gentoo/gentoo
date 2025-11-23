# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Virtual MIDI keyboard for JACK MIDI"
HOMEPAGE="http://pin.if.uz.zgora.pl/~trasz/jack-keyboard/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="lash X"

DEPEND="
	dev-libs/glib:2
	virtual/jack
	x11-libs/gtk+:2
	lash? ( media-sound/lash )
	X? ( x11-libs/libX11 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-man.patch"
	"${FILESDIR}/${P}-no-lash-warning.patch" # thx to Debian
	"${FILESDIR}/${P}-cmake4.patch" # bug 957743, downstream
)

src_configure() {
	local mycmakeargs=(
		-DJackEnable=ON # though configurable, does not compile withou jack
		-DLashEnable=$(usex lash)
		-DX11Enable=$(usex X)
	)

	cmake_src_configure
}
