# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

MY_P=${P/-/_}

DESCRIPTION="Amateur radio SSTV software"
HOMEPAGE="http://users.telenet.be/on4qz/"
SRC_URI="http://users.telenet.be/on4qz/qsstv/downloads/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/hamlib:=
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
	eapply_user
	# fix docdirectory, install path and hamlib search path
	sed -i -e "s:/doc/\$\$TARGET:/doc/${PF}:" \
		-e "s:-lhamlib:-L/usr/$(get_libdir)/hamlib -lhamlib:g" \
		qsstv.pro || die
}

src_configure() {
	eqmake5 PREFIX="/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README.txt
}
