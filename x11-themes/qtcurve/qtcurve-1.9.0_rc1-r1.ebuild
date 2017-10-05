# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_AUTODEPS="false"
inherit kde5

DESCRIPTION="Widget styles for Qt and GTK2"
HOMEPAGE="https://cgit.kde.org/qtcurve.git"

LICENSE="LGPL-2+"
SLOT="0"
IUSE="+X gtk nls plasma qt4 +qt5 test"

if [[ "${PV}" != 9999 ]] ; then
	SRC_URI="https://github.com/KDE/qtcurve/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~hppa ppc ppc64 ~sparc x86"
	S="${WORKDIR}/${P/_/-}"
fi

REQUIRED_USE="gtk? ( X )
	|| ( gtk qt4 qt5 )
	plasma? ( qt5 )
"

COMMON_DEPEND="
	gtk? ( x11-libs/gtk+:2 )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtsvg:4
	)
	qt5? (
		$(add_qt_dep qtdbus)
		$(add_qt_dep qtgui)
		$(add_qt_dep qtsvg)
		$(add_qt_dep qtwidgets)
		$(add_qt_dep qtx11extras)
	)
	plasma? (
		$(add_frameworks_dep frameworkintegration)
		$(add_frameworks_dep karchive)
		$(add_frameworks_dep kcompletion)
		$(add_frameworks_dep kconfig)
		$(add_frameworks_dep kconfigwidgets)
		$(add_frameworks_dep kcoreaddons)
		$(add_frameworks_dep kdelibs4support)
		$(add_frameworks_dep kguiaddons)
		$(add_frameworks_dep ki18n)
		$(add_frameworks_dep kiconthemes)
		$(add_frameworks_dep kio)
		$(add_frameworks_dep kwidgetsaddons)
		$(add_frameworks_dep kwindowsystem)
		$(add_frameworks_dep kxmlgui)
		$(add_qt_dep qtprintsupport)
	)
	X? (
		x11-libs/libX11
		x11-libs/libxcb
	)
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
RDEPEND="${COMMON_DEPEND}
	!x11-themes/gtk-engines-qtcurve
"

DOCS=( AUTHORS ChangeLog.md README.md TODO.md )

#PATCHES=(
#	"${FILESDIR}/${P}-add_utils_include.patch"
#)

pkg_setup() {
	# bug #498776
	if ! version_is_at_least 4.7 $(gcc-version) ; then
		append-cxxflags -Doverride=
	fi
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"
		-DQTC_QT4_ENABLE_KDE=OFF
		-DQTC_QT4_ENABLE_KWIN=OFF
		-DQTC_KDE4_DEFAULT_HOME=ON
		-DENABLE_GTK2="$(usex gtk)"
		-DENABLE_QT4="$(usex qt4)"
		-DENABLE_QT5="$(usex qt5)"
		-DENABLE_TEST="$(usex test)"
		-DQTC_ENABLE_X11="$(usex X)"
		-DQTC_INSTALL_PO="$(usex nls)"
		-DQTC_QT5_ENABLE_KDE="$(usex plasma)"
	)

	kde5_src_configure
}
