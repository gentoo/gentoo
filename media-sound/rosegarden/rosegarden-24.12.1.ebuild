# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg virtualx

DESCRIPTION="MIDI and audio sequencer and notation editor"
HOMEPAGE="https://www.rosegardenmusic.com/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="lirc"

BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"
RDEPEND="
	dev-qt/qtbase:6[gui,network,widgets,xml]
	media-libs/alsa-lib:=
	>=media-libs/dssi-1.0.0:=
	media-libs/ladspa-sdk:=
	media-libs/liblo:=
	media-libs/liblrdf:=
	media-libs/libsamplerate:=
	media-libs/libsndfile:=
	sci-libs/fftw:3.0
	sys-libs/zlib:=
	virtual/jack
	x11-libs/libSM:=
	lirc? ( app-misc/lirc:= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-24.06-includes.patch"
	"${FILESDIR}/${PN}-24.12-parameter-declaration.patch"
	"${FILESDIR}/${PN}-24.12-missing-includes.patch"
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_LIRC=$(usex !lirc)
		-DUSE_QT6=ON
	)
	cmake_src_configure
}

src_test() {
	# bug 701682, tries to open network socket and fails.
	local myctestargs=(
		-E "(test_notationview_selection)"
	)
	virtx cmake_src_test
}
