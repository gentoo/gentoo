# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIRTUALX_REQUIRED="test"
inherit ecm

DESCRIPTION="Multi platform Qt notification framework"
HOMEPAGE="https://techbase.kde.org/Projects/Snorenotify"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="sound test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5
	sound? ( dev-qt/qtmultimedia:5 )
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

PATCHES=(
	"${FILESDIR}/${P}-desktop.patch"
	"${FILESDIR}/${P}-include.patch"
)

src_prepare() {
	ecm_src_prepare
	sed -e "/Categories/s/;Qt//" \
		-i src/{settings/snoresettings,daemon/snorenotify}.desktop.in || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package sound Qt5Multimedia)
		$(cmake_use_find_package test Qt5Test)
	)

	ecm_src_configure
}
