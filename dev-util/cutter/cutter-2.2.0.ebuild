# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake toolchain-funcs xdg-utils python-single-r1

MY_P="${PN^}-v${PV}"

DESCRIPTION="A Qt and C++ GUI for rizin reverse engineering framework"
HOMEPAGE="https://cutter.re https://github.com/rizinorg/cutter/"
SRC_URI="https://github.com/rizinorg/${PN}/releases/download/v${PV}/${MY_P}-src.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="CC-BY-SA-3.0 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="graphviz"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	>=dev-util/rizin-0.5.0:=
	graphviz? ( media-gfx/graphviz )"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_COMPILER="$(tc-getCXX)"
		-DCMAKE_C_COMPILER="$(tc-getCC)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCUTTER_ENABLE_GRAPHVIZ="$(usex graphviz)"
		-DCUTTER_ENABLE_KSYNTAXHIGHLIGHTING=OFF
		-DCUTTER_ENABLE_PYTHON=ON
		-DCUTTER_USE_ADDITIONAL_RIZIN_PATHS=OFF
		-DCUTTER_USE_BUNDLED_RIZIN=OFF
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
