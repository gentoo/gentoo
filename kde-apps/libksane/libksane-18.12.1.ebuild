# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_BLOCK_SLOT4="false"
inherit kde5

DESCRIPTION="SANE Library interface based on KDE Frameworks"
LICENSE="|| ( LGPL-2.1 LGPL-3 )"
KEYWORDS="~amd64 ~x86"
IUSE="kwallet"

DEPEND="
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	media-gfx/sane-backends
	kwallet? ( $(add_frameworks_dep kwallet) )
"
RDEPEND="${DEPEND}
	!<kde-apps/libksane-15.08.3-r1:4
	!kde-base/legacy-icons
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package kwallet KF5Wallet)
	)
	kde5_src_configure
}
