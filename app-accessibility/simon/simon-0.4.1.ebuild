# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# KEEP KDE ECLASSES OUT OF HERE

# TODO: qaccessibilityclient support (not in portage)
# https://projects.kde.org/projects/playground/accessibility/libkdeaccessibilityclient/repository
# TODO: julius

EAPI=5

inherit eutils multilib gnome2-utils cmake-utils

DESCRIPTION="Open-source speech recognition program for replacing mouse and keyboard"
HOMEPAGE="http://simon-listens.org/"
SRC_URI="mirror://kde/stable/simon/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="kdepim libsamplerate nls opencv sphinx"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtscript:4
	dev-qt/qtsql:4
	kde-base/kdelibs:4
	media-libs/alsa-lib
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/qwt:6
	kdepim? ( kde-base/kdepimlibs:4 )
	libsamplerate? ( media-libs/libsamplerate )
	nls? (
		kde-apps/kde4-l10n
		virtual/libintl
	)
	opencv? ( media-libs/opencv )
	sphinx? (
		>=app-accessibility/pocketsphinx-0.8
		>=app-accessibility/sphinxbase-0.8
		>=app-accessibility/SphinxTrain-1
	)
	!sphinx? ( app-accessibility/julius )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-libdir.patch
	"${FILESDIR}"/${P}-linguas.patch
	"${FILESDIR}"/${P}-sphinx.patch
	"${FILESDIR}"/${P}-opencv-include.patch
)

src_configure() {
	local mycmakeargs=(
		-DSIMON_LIB_INSTALL_DIR=/usr/$(get_libdir)
		-DBackendType=$(usex sphinx "both" "jhtk")
		$(cmake-utils_use_with sphinx Sphinxbase)
		$(cmake-utils_use_with sphinx Pocketsphinx)
		$(cmake-utils_use_with kdepim KdepimLibs)
		$(cmake-utils_use_with libsamplerate LibSampleRate)
		$(cmake-utils_use_with opencv OpenCV)
		$(cmake-utils_use_enable nls NLS)
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	elog "optional dependencies:"
	elog "  kde-apps/jovie (support for Jovie TTS system)"
	use sphinx && elog "  app-accessibility/julius (alternative backend)"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
