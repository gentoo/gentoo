# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PLOCALES="ca cs da de el en es et eu fr gl hu it lv nb nl pl pt ru sr sv tr zh"

inherit cmake-utils l10n

DESCRIPTION="Application to create and manage beer recipes"
HOMEPAGE="http://www.brewtarget.org/"
SRC_URI="https://github.com/Brewtarget/${PN}/releases/download/v${PV}/${PN}_${PV}.orig.tar.xz"

LICENSE="GPL-3 WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

remove_locale() {
	sed -i -e "/bt_${1}\.ts/d" CMakeLists.txt || die
}

src_prepare() {
	l10n_find_plocales_changes "${S}/translations" bt_ .ts
	l10n_for_each_disabled_locale_do remove_locale

	# Tests are bogus, don't build them
	sed -i -e '/Qt5Test/d' CMakeLists.txt || die
	sed -i -e '/=Tests=/,/=Installs=/d' src/CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDO_RELEASE_BUILD=ON
		-DNO_MESSING_WITH_FLAGS=ON
	)
	cmake-utils_src_configure
}
