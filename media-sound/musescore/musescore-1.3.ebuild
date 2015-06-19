# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/musescore/musescore-1.3.ebuild,v 1.2 2014/04/16 06:11:17 polynomial-c Exp $

EAPI=5
inherit cmake-utils eutils font

MY_P="mscore-${PV}"

DESCRIPTION="WYSIWYG Music Score Typesetter"
HOMEPAGE="http://mscore.sourceforge.net"
SRC_URI="mirror://sourceforge/mscore/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	>=media-libs/libsndfile-1.0.19
	media-libs/portaudio
	media-sound/fluidsynth
	media-sound/jack-audio-connection-kit
	sys-libs/zlib
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qt3support:4
	dev-qt/qtscript:4
	dev-qt/qtsvg:4
	x11-libs/qtscriptgenerator"
DEPEND="${RDEPEND}
	dev-texlive/texlive-context
	app-doc/doxygen
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}/mscore"
VARTEXFONTS="${T}/fonts"
FONT_SUFFIX="ttf"
FONT_S="${S}/mscore/fonts"

src_prepare() {
	# don't build redundant qtscriptgenerator libs
	sed -i '/^set(BUILD_SCRIPTGEN/s/TRUE/FALSE/' CMakeLists.txt || die

	epatch "${FILESDIR}"/${P}-cflags.patch \
		"${FILESDIR}"/${P}-freetype251.patch
}

src_compile() {
	cmake-utils_src_make lupdate
	cmake-utils_src_make lrelease
	cmake-utils_src_make
}

src_install() {
	cmake-utils_src_install
	font_src_install
	dodoc ChangeLog NEWS README
	doman packaging/mscore.1
}
