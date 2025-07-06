# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=efb9e510f50f8147f05054d77c3ef433a8b9390e
inherit cmake kde.org

DESCRIPTION="Widget styles for Qt and GTK2"
HOMEPAGE="https://invent.kde.org/system/qtcurve"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="gtk plasma qt5 +qt6 test X"

REQUIRED_USE="gtk? ( X )
	|| ( gtk qt5 qt6 )
	plasma? ( qt6 )
"
RESTRICT="test"

DEPEND="
	gtk? (
		dev-libs/glib:2
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
	)
	plasma? (
		kde-frameworks/frameworkintegration:6
		kde-frameworks/karchive:6
		kde-frameworks/kcolorscheme:6
		kde-frameworks/kcompletion:6
		kde-frameworks/kconfig:6
		kde-frameworks/kconfigwidgets:6
		kde-frameworks/kcoreaddons:6
		kde-frameworks/kguiaddons:6
		kde-frameworks/ki18n:6
		kde-frameworks/kiconthemes:6
		kde-frameworks/kio:6
		kde-frameworks/kwidgetsaddons:6
		kde-frameworks/kwindowsystem:6[X]
		kde-frameworks/kxmlgui:6
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		X? ( dev-qt/qtx11extras:5 )
	)
	qt6? (
		dev-qt/qtbase:6[dbus,gui,widgets]
		dev-qt/qtsvg:6
		X? ( dev-qt/qtbase:6=[X] )
	)
	X? (
		x11-libs/libX11
		x11-libs/libxcb
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	plasma? (
		kde-frameworks/extra-cmake-modules:0
		kde-frameworks/ki18n:6
	)
"

DOCS=( AUTHORS ChangeLog.md README.md TODO.md )

PATCHES=( "${FILESDIR}/${P}-manhandle-cmake.patch" ) # bug 959633

src_configure() {
	local mycmakeargs=(
		-DENABLE_QT4=OFF
		-DQTC_QT4_ENABLE_KDE=OFF
		-DQTC_KDE4_DEFAULT_HOME=ON
		-DENABLE_GTK2=$(usex gtk)
		-DQTC_INSTALL_PO=$(usex plasma)
		-DENABLE_QT5=$(usex qt5)
		-DENABLE_QT6=$(usex qt6)
		-DQTC_QT6_ENABLE_KDE=$(usex plasma)
		-DBUILD_TESTING=$(usex test)
		-DQTC_ENABLE_X11=$(usex X)
	)
	use plasma && mycmakeargs+=( -DQT_MAJOR_VERSION=6 )

	cmake_src_configure
}
