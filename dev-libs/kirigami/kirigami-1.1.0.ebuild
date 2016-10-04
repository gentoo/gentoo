# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Lightweight user interface framework for mobile and convergent applications"
HOMEPAGE="https://techbase.kde.org/Kirigami"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="examples plasma"

RDEPEND="
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsvg)
	plasma? ( $(add_frameworks_dep plasma) )
"
DEPEND="${RDEPEND}
	$(add_qt_dep linguist-tools)
"

src_prepare() {
	kde5_src_prepare

	sed -i -e "/find_package(Qt5/s/Test//" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
		-DPLASMA_ENABLED=$(usex plasma)
	)

	kde5_src_configure
}
