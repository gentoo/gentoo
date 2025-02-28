# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="Barcode encoding library supporting over 50 symbologies"
HOMEPAGE="https://www.zint.org.uk/"
SRC_URI="
	https://downloads.sourceforge.net/${PN}/${P}-src.tar.gz
"
S="${WORKDIR}/${P}-src"

# see LICENSE
LICENSE="BSD GPL-3+"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="gui png test"
RESTRICT="!test? ( test )"

DEPEND="
	gui? (
		dev-qt/qtbase:6[gui,widgets]
		dev-qt/qtsvg:6
		dev-qt/qttools:6[widgets]
	)
	png? (
		media-libs/libpng:=
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DZINT_FRONTEND=ON
		-DZINT_QT6=$(usex gui)
		-DZINT_TEST=$(usex test)
		-DZINT_UNINSTALL=OFF
		-DZINT_USE_PNG=$(usex png)
		-DZINT_USE_QT=$(usex gui)
	)
	cmake_src_configure
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	cmake_src_test -j1 # parallel tests cause failures to each other
}

src_install() {
	cmake_src_install
	einstalldocs
	if use gui; then
		domenu zint-qt.desktop
		doicon zint-qt.png
	fi
}
