# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_KDEINSTALLDIRS="false"
KDE_AUTODEPS="false"
inherit kde5

DESCRIPTION="Widget styles for Qt and GTK2"
HOMEPAGE="https://cgit.kde.org/qtcurve.git"

LICENSE="LGPL-2+"
SLOT="0"
IUSE="+X gtk nls plasma +qt5 test"

if [[ "${PV}" != 9999 ]] ; then
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
"
DEPEND="
	gtk? ( x11-libs/gtk+:2 )
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
	qt5? (
		$(add_qt_dep qtdbus)
		$(add_qt_dep qtgui)
		$(add_qt_dep qtsvg)
		$(add_qt_dep qtwidgets)
		X? ( $(add_qt_dep qtx11extras) )
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
		-DQTC_ENABLE_X11="$(usex X)"
		-DQTC_INSTALL_PO="$(usex nls)"
		-DQTC_QT5_ENABLE_KDE="$(usex plasma)"
	)

	kde5_src_configure
}
