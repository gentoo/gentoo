# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="Software meterbridge for the UNIX based JACK audio system"
HOMEPAGE="http://plugin.org.uk/meterbridge/"
SRC_URI="http://plugin.org.uk/meterbridge/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="media-sound/jack-audio-connection-kit
	>=media-libs/libsdl-1.2
	>=media-libs/sdl-image-1.2.10[png]
	virtual/opengl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-gcc41.patch"
	"${FILESDIR}/${P}-asneeded.patch"
	"${FILESDIR}/${P}-cflags.patch"
	"${FILESDIR}/${P}-setrgba.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog
}
