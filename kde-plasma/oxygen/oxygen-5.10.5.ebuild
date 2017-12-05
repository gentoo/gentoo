# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5 multibuild

DESCRIPTION="Oxygen visual style for the Plasma desktop"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/oxygen"
KEYWORDS="amd64 ~arm x86"
IUSE="qt4 wayland"

COMMON_DEPEND="
	$(add_frameworks_dep frameworkintegration)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_plasma_dep kdecoration)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	x11-libs/libxcb
	qt4? (
		>=dev-qt/qtcore-4.8.7-r2:4
		>=dev-qt/qtdbus-4.8.7:4
		>=dev-qt/qtgui-4.8.7:4
		kde-frameworks/kdelibs:4
		x11-libs/libX11
	)
	wayland? ( $(add_frameworks_dep kwayland) )
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kservice)
	qt4? (
		dev-util/automoc:0
		virtual/pkgconfig
	)
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep kde-cli-tools)
	qt4? (
		!kde-plasma/kstyles:4
		!kde-plasma/liboxygenstyle:4
	)
	!kde-plasma/kdebase-cursors:4
"

pkg_setup() {
	if use qt4 && [[ $(gcc-major-version) -lt 5 ]] ; then
		ewarn "A GCC version older than 5 was detected. There may be trouble. See also Gentoo bug #595618"
	fi

	kde5_pkg_setup
	MULTIBUILD_VARIANTS=( kf5 $(usev qt4) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			$(cmake-utils_use_find_package wayland KF5Wayland)
		)

		if [[ ${MULTIBUILD_VARIANT} = qt4 ]] ; then
			mycmakeargs+=( -DUSE_KDE4=true )
		fi

		kde5_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant kde5_src_compile
}

src_test() {
	multibuild_foreach_variant kde5_src_test
}

src_install() {
	multibuild_foreach_variant kde5_src_install
}
