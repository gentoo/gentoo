# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="MIDI and audio sequencer and notation editor"
HOMEPAGE="https://www.rosegardenmusic.com/"
SRC_URI="https://downloads.sourceforge.net/project/rosegarden/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="lirc lv2 test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"
RDEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[gui,network,widgets,xml]
	media-libs/alsa-lib
	>=media-libs/dssi-1.0.0:=
	media-libs/ladspa-sdk
	media-libs/liblo
	media-libs/liblrdf
	media-libs/libsamplerate
	media-libs/libsndfile
	sci-libs/fftw:3.0=
	virtual/jack
	virtual/zlib:=
	lirc? ( app-misc/lirc )
	lv2? (
		media-libs/lilv
		>=media-libs/lv2-1.18.0
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-24.06-includes.patch"
	"${FILESDIR}/${PN}-24.12-parameter-declaration.patch"
	"${FILESDIR}/${PN}-24.12-missing-includes.patch"
	"${FILESDIR}/${PN}-25.12-missing-includes.patch"
	"${FILESDIR}/${PN}-25.12-bump_cmake.patch"
	"${FILESDIR}/${PN}-25.12-opt_lilv.patch"
	"${FILESDIR}/${PN}-25.12-opt_pch.patch"
	# there is a linking problem when tests are enabled: https://bugs.gentoo.org/957755
	# force static until it's fixed
	"${FILESDIR}/${PN}-25.12-force_static.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DDISABLE_LILV=$(usex !lv2)
		-DDISABLE_LIRC=$(usex !lirc)
		-DDISABLE_PCH=ON
		-DUSE_GTK2=OFF
		-DUSE_QT6=ON
	)
	cmake_src_configure
}

src_test() {
	QT_QPA_PLATFORM=offscreen cmake_src_test
}
