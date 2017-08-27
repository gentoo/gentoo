# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_LINGUAS="ast bs ca ca@valencia cs da de el en_GB es et fa fi fr ga gl
hu ia ja kk lt mr nds nl pl pt pt_BR sk sl sv tr ug uk zh_CN zh_TW"
SQL_REQUIRED="always"
inherit kde4-base

DESCRIPTION="Open-source speech recognition program for replacing mouse and keyboard"
HOMEPAGE="http://simon-listens.org/"
SRC_URI="mirror://kde/unstable/simon/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libsamplerate opencv sphinx"

RDEPEND="
	media-libs/alsa-lib
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/qwt:6[qt4(+)]
	libsamplerate? ( media-libs/libsamplerate )
	opencv? ( media-libs/opencv )
	sphinx? (
		>=app-accessibility/pocketsphinx-0.8
		>=app-accessibility/sphinxbase-0.8
		>=app-accessibility/SphinxTrain-1
	)
	!sphinx? ( app-accessibility/julius )
"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-0.4.1-libdir.patch )

src_configure() {
	local mycmakeargs=(
		-DSIMON_LIB_INSTALL_DIR=/usr/$(get_libdir)
		-DWITH_KdepimLibs=OFF
		-DUSE_PLASMA=OFF
		-DWITH_LibSampleRate=$(usex libsamplerate)
		-DWITH_OpenCV=$(usex opencv)
		-DBackendType=$(usex sphinx "both" "jhtk")
		$(cmake-utils_use_find_package sphinx Sphinxbase)
		$(cmake-utils_use_find_package sphinx Pocketsphinx)
	)

	kde4-base_src_configure
}

pkg_postinst() {
	kde4-base_pkg_postinst

	elog "Optional dependencies:"
	elog "  kde-apps/jovie (support for Jovie TTS system)"
	use sphinx && elog "  app-accessibility/julius (alternative backend)"
}
