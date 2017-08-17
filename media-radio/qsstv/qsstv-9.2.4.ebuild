# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils qt4-r2

MY_P=${P/-/_}

DESCRIPTION="Amateur radio SSTV software"
HOMEPAGE="http://users.telenet.be/on4qz/"
SRC_URI="http://users.telenet.be/on4qz/qsstv/downloads/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="dev-qt/qtcore:4[qt3support]
	dev-qt/qtgui:4
	media-libs/hamlib
	media-libs/openjpeg:2
	media-libs/alsa-lib
	media-sound/pulseaudio
	media-libs/libv4l
	sci-libs/fftw:3.0="
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# fix docdirectory, install path and hamlib search path
	sed -i -e "s:/doc/\$\$TARGET:/doc/${PF}:" \
		-e "s:-lhamlib:-L/usr/$(get_libdir)/hamlib -lhamlib:g" \
		qsstv/qsstv.pro || die

	# fix hardcoded path to openjpeg headers
	sed -i -e "s:openjpeg-2.1/::" qsstv/utils/color.cpp ||die
	sed -i -e "s:/usr/include/openjpeg-2.1:$(pkg-config --cflags-only-I libopenjp2):" \
		-e "s:-I/usr:/usr:" qsstv/qsstv.pro ||die
}
