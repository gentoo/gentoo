# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic kde5 multibuild

DESCRIPTION="Breeze visual style for the Plasma desktop"
HOMEPAGE="https://cgit.kde.org/breeze.git"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="qt4 wayland X"

REQUIRED_USE="qt4? ( X )"

COMMON_DEPEND="
	$(add_frameworks_dep frameworkintegration)
	$(add_frameworks_dep kcmutils)
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
	qt4? (
		kde-frameworks/kdelibs:4
		x11-libs/libX11
	)
	wayland? ( $(add_frameworks_dep kwayland) )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libxcb
	)
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kpackage)
	qt4? ( dev-util/automoc:0 )
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep breeze-icons)
	$(add_plasma_dep kde-cli-tools)
"

pkg_setup() {
	kde5_pkg_setup
	MULTIBUILD_VARIANTS=( kf5 $(usev qt4) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=()

		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			use debug || append-cppflags -DQT_NO_DEBUG
			mycmakeargs+=(
				-DUSE_KDE4=true
				-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
			)
			cmake-utils_src_configure
		else
			mycmakeargs+=(
				$(cmake-utils_use_find_package wayland KF5Wayland)
				$(cmake-utils_use_find_package X XCB)
			)
			kde5_src_configure
		fi
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
