# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.60.0
QTMIN=5.12.3
inherit cmake kde.org

DESCRIPTION="Widget styles for Qt and GTK2"
HOMEPAGE="https://invent.kde.org/system/qtcurve"

LICENSE="LGPL-2+"
SLOT="0"
IUSE="gtk nls plasma +qt5 test +X"

if [[ ${KDE_BUILD_TYPE} = release ]] ; then
	SRC_URI="https://github.com/KDE/qtcurve/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~hppa ppc ppc64 ~sparc x86"
	S="${WORKDIR}/${P/_/-}"
fi

REQUIRED_USE="gtk? ( X )
	|| ( gtk qt5 )
	plasma? ( qt5 )
"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	plasma? ( >=kde-frameworks/extra-cmake-modules-${KFMIN}:5 )
"
DEPEND="
	gtk? ( x11-libs/gtk+:2 )
	plasma? (
		>=dev-qt/qtprintsupport-${QTMIN}:5
		>=kde-frameworks/frameworkintegration-${KFMIN}:5
		>=kde-frameworks/karchive-${KFMIN}:5
		>=kde-frameworks/kcompletion-${KFMIN}:5
		>=kde-frameworks/kconfig-${KFMIN}:5
		>=kde-frameworks/kconfigwidgets-${KFMIN}:5
		>=kde-frameworks/kcoreaddons-${KFMIN}:5
		>=kde-frameworks/kdelibs4support-${KFMIN}:5
		>=kde-frameworks/kguiaddons-${KFMIN}:5
		>=kde-frameworks/ki18n-${KFMIN}:5
		>=kde-frameworks/kiconthemes-${KFMIN}:5
		>=kde-frameworks/kio-${KFMIN}:5
		>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
		>=kde-frameworks/kwindowsystem-${KFMIN}:5
		>=kde-frameworks/kxmlgui-${KFMIN}:5
	)
	qt5? (
		>=dev-qt/qtdbus-${QTMIN}:5
		>=dev-qt/qtgui-${QTMIN}:5
		>=dev-qt/qtsvg-${QTMIN}:5
		>=dev-qt/qtwidgets-${QTMIN}:5
		X? ( >=dev-qt/qtx11extras-${QTMIN}:5 )
	)
	X? (
		x11-libs/libX11
		x11-libs/libxcb
	)
"
RDEPEND="${DEPEND}"

RESTRICT+=" test"

DOCS=( AUTHORS ChangeLog.md README.md TODO.md )

PATCHES=(
	"${FILESDIR}/${PN}-1.9.0-build_testing.patch"
	"${FILESDIR}/${PN}-1.9.0-no-X-buildfix.patch"
	"${FILESDIR}/${PN}-1.9.0-gcc9.patch"
	"${FILESDIR}/${PN}-1.9.0-libreoffice-crashfix.patch"
)

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"
		-DENABLE_QT4=OFF
		-DQTC_QT4_ENABLE_KDE=OFF
		-DQTC_KDE4_DEFAULT_HOME=ON
		-DENABLE_GTK2="$(usex gtk)"
		-DENABLE_QT5="$(usex qt5)"
		-DBUILD_TESTING="$(usex test)"
		-DQTC_ENABLE_X11="$(usex X)"
		-DQTC_INSTALL_PO="$(usex nls)"
		-DQTC_QT5_ENABLE_KDE="$(usex plasma)"
	)

	cmake_src_configure
}
