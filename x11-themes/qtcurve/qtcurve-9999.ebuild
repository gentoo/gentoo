# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils kde5-functions git-r3

DESCRIPTION="A set of widget styles for Qt and GTK2"
HOMEPAGE="https://quickgit.kde.org/?p=qtcurve.git"
EGIT_REPO_URI="git://anongit.kde.org/qtcurve"

LICENSE="LGPL-2+"
SLOT="0"
IUSE="+X gtk nls plasma qt4 +qt5 test"
KEYWORDS=""

REQUIRED_USE="gtk? ( X )
	|| ( gtk qt4 qt5 )
	plasma? ( qt5 )
"

RDEPEND="X? (
		x11-libs/libX11
		x11-libs/libxcb
	)
	gtk? ( x11-libs/gtk+:2 )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtsvg:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
	)
	plasma? (
		dev-qt/qtprintsupport:5
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
	)
	!x11-themes/gtk-engines-qtcurve"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${P/_/}"

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
	local mycmakeargs

	mycmakeargs=(
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

	cmake-utils_src_configure
}
