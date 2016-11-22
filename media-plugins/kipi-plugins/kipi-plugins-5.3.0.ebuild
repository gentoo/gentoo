# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_MIN_VERSION="3.0"
KDE_TEST="true"
inherit kde5

DESCRIPTION="Plugins for the KDE Image Plugin Interface"
HOMEPAGE="https://www.digikam.org/"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="flashexport mediawiki +remotestorage vkontakte"

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
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep libkipi '' '' '5=')
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	$(add_qt_dep qtxmlpatterns)
	flashexport? ( $(add_frameworks_dep karchive) )
	mediawiki? ( net-libs/libmediawiki:5 )
	remotestorage? ( $(add_frameworks_dep kio) )
	vkontakte? ( net-libs/libkvkontakte:5 )
"
DEPEND="${COMMON_DEPEND}
	$(add_qt_dep qtconcurrent)
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	!media-plugins/kipi-plugins:4
"

src_prepare() {
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
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
		$(cmake-utils_use_find_package remotestorage KF5KIO)
		$(cmake-utils_use_find_package vkontakte KF5Vkontakte)
	)

	kde5_src_configure
}
