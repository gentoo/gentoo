# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="true"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Plugins for the KDE Image Plugin Interface"
HOMEPAGE="http://www.digikam.org/"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
KEYWORDS="~amd64 ~x86"
IUSE="flashexport mediawiki vkontakte"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	MY_PV="${PV/_/-}"
	MY_P="digikam-${MY_PV}"

	if [[ ${PV} =~ beta[0-9]$ ]]; then
		SRC_BRANCH="unstable"
	else
		SRC_BRANCH="stable"
	fi

	SRC_URI="mirror://kde/${SRC_BRANCH}/digikam/${MY_P}.tar.xz"

	S="${WORKDIR}/${MY_P}/extra/${PN}"
fi

COMMON_DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	$(add_qt_dep qtxmlpatterns)
	kde-apps/libkipi:5=
	flashexport? ( $(add_frameworks_dep karchive) )
	mediawiki? ( net-libs/libmediawiki:5 )
	vkontakte? ( net-libs/libkvkontakte:5 )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	!media-plugins/kipi-plugins:4
"

# hangs
RESTRICT="test"

src_prepare() {
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		# prepare the handbook
		mv "${WORKDIR}"/${MY_P}/doc/${PN} "${S}"/doc || die

		if use handbook; then
			echo "add_subdirectory( doc )" >> CMakeLists.txt || die
		fi

		if [[ ${SRC_BRANCH} = stable ]]; then
			# prepare the translations
			mv "${WORKDIR}/${MY_P}/po" po || die
			find po -name "*.po" -and -not -name "kipiplugin*.po" -delete || die
			echo "find_package(Gettext REQUIRED)" >> CMakeLists.txt || die
			echo "add_subdirectory( po )" >> CMakeLists.txt || die
		fi
	fi

	kde5_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package flashexport KF5Archive)
		$(cmake-utils_use_find_package mediawiki KF5MediaWiki)
		$(cmake-utils_use_find_package vkontakte KF5Vkontakte)
	)

	kde5_src_configure
}
