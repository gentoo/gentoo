# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework for searching and managing metadata"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kfilemetadata)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	>=dev-db/lmdb-0.9.17
"
RDEPEND="${DEPEND}
	!kde-base/baloo:4[-minimal(-)]
"

PATCHES=(
	"${FILESDIR}/${P}-runtime-crash.patch"
	"${FILESDIR}/${P}-size-limit.patch"
	"${FILESDIR}/${P}-zerotimestamp-crash.patch"
	"${FILESDIR}/${P}-thread-safety.patch"
	"${FILESDIR}/${P}-dont-corrupt.patch"
)

pkg_postinst() {
	kde5_pkg_postinst
	if use x86; then
		ewarn "The baloo index size limit for 32-bit is 1GB. For large homes, exclude"
		ewarn "subdirectories in System Settings / Search to avoid random segfaults."
		ewarn "For more information, visit: https://bugs.kde.org/show_bug.cgi?id=364475"
	fi
}
