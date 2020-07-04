# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_BRANCH="kf5"
ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
inherit ecm kde.org

DESCRIPTION="Open-source speech recognition program for replacing mouse and keyboard"
HOMEPAGE="https://simon-listens.org/"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/unstable/simon/${PV}/${P}.tar.xz"
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="5"
IUSE="libsamplerate opencv pim sphinx"

DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtx11extras:5
	kde-apps/okular:5
	kde-frameworks/karchive:5
	kde-frameworks/kcmutils:5
	kde-frameworks/kcompletion:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kcrash:5
	kde-frameworks/kdbusaddons:5
	kde-frameworks/kdelibs4support:5
	kde-frameworks/kguiaddons:5
	kde-frameworks/khtml:5
	kde-frameworks/ki18n:5
	kde-frameworks/kiconthemes:5
	kde-frameworks/kio:5
	kde-frameworks/kparts:5
	kde-frameworks/ktexteditor:5
	kde-frameworks/kwidgetsaddons:5
	kde-frameworks/kxmlgui:5
	media-libs/alsa-lib
	media-libs/libqaccessibilityclient:5
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/qwt:6=
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package pim KF5CalendarCore)
		$(cmake-utils_use_find_package pim KF5Akonadi)
		-DWITH_LibSampleRate=$(usex libsamplerate)
		-DWITH_OpenCV=$(usex opencv)
		-DBackendType=$(usex sphinx "both" "jhtk")
		$(cmake-utils_use_find_package sphinx Sphinxbase)
		$(cmake-utils_use_find_package sphinx Pocketsphinx)
		-DQWT_INCLUDE_DIR=/usr/include/qwt6
		-DQWT_LIBRARY=/usr/$(get_libdir)/libqwt6-qt5.so
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	elog "Optional dependency:"
	use sphinx && elog "  app-accessibility/julius (alternative backend)"
}
