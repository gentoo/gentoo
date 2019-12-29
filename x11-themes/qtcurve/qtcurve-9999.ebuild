# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake kde.org

DESCRIPTION="Widget styles for Qt and GTK2"
HOMEPAGE="https://cgit.kde.org/qtcurve.git"

LICENSE="LGPL-2+"
SLOT="0"
IUSE="gtk nls plasma +qt5 test +X"

if [[ ${KDE_BUILD_TYPE} = release ]] ; then
	SRC_URI="https://github.com/KDE/qtcurve/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
	S="${WORKDIR}/${P/_/-}"
fi

REQUIRED_USE="gtk? ( X )
	|| ( gtk qt5 )
	plasma? ( qt5 )
"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	plasma? ( kde-frameworks/extra-cmake-modules:5 )
"
DEPEND="
	gtk? ( x11-libs/gtk+:2 )
	plasma? (
		dev-qt/qtprintsupport:5
		kde-frameworks/frameworkintegration:5
		kde-frameworks/karchive:5
		kde-frameworks/kcompletion:5
		kde-frameworks/kconfig:5
		kde-frameworks/kconfigwidgets:5
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kdelibs4support:5
		kde-frameworks/kguiaddons:5
		kde-frameworks/ki18n:5
		kde-frameworks/kiconthemes:5
		kde-frameworks/kio:5
		kde-frameworks/kwidgetsaddons:5
		kde-frameworks/kwindowsystem:5
		kde-frameworks/kxmlgui:5
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		X? ( dev-qt/qtx11extras:5 )
	)
	X? (
		x11-libs/libX11
		x11-libs/libxcb
	)
"
RDEPEND="${DEPEND}"

RESTRICT+=" test"

DOCS=( AUTHORS ChangeLog.md README.md TODO.md )

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
