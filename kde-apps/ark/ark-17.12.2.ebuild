# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="optional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE Archiving tool"
HOMEPAGE="https://www.kde.org/applications/utilities/ark
https://utils.kde.org/projects/ark/"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 lzma zip zlib"

RDEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kpty)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	app-arch/libarchive:=[bzip2?,lzma?,zlib?]
	sys-libs/zlib
	zip? ( >=dev-libs/libzip-1.2.0:= )
"
DEPEND="${RDEPEND}
	$(add_qt_dep qtconcurrent)
	sys-devel/gettext
"

# bug #560548, last checked with 16.04.1
RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package bzip2 BZip2)
		$(cmake-utils_use_find_package lzma LibLZMA)
		$(cmake-utils_use_find_package zip LibZip)
		$(cmake-utils_use_find_package zlib ZLIB)
	)

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst

	# not a typo, app-arch/unar is a real package
	if ! has_version app-arch/unar ; then
		elog "For handling rar archives, install app-arch/unar"
	fi

	if ! has_version app-arch/p7zip ; then
		elog "For handling 7-Zip archives, install app-arch/p7zip"
	fi

	if ! has_version app-arch/lrzip ; then
		elog "For handling lrz archives, install app-arch/lrzip"
	fi
}
