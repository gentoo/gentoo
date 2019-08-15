# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
inherit kde5

DESCRIPTION="Plugins for the KDE Image Plugin Interface"
HOMEPAGE="https://userbase.kde.org/KIPI https://cgit.kde.org/kipi-plugins.git/"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="flashexport mediawiki +remotestorage vkontakte"

BDEPEND="sys-devel/gettext"
RDEPEND="
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
DEPEND="${RDEPEND}
	$(add_qt_dep qtconcurrent)
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package flashexport KF5Archive)
		$(cmake-utils_use_find_package mediawiki KF5MediaWiki)
		$(cmake-utils_use_find_package remotestorage KF5KIO)
		$(cmake-utils_use_find_package vkontakte KF5Vkontakte)
	)

	kde5_src_configure
}
