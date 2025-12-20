# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit cmake xdg-utils python-single-r1

MY_P="${PN^}-v${PV}"

DESCRIPTION="A Qt and C++ GUI for rizin reverse engineering framework"
HOMEPAGE="https://cutter.re https://github.com/rizinorg/cutter/"
SRC_URI="https://github.com/rizinorg/${PN}/releases/download/v${PV}/${MY_P}-src.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="CC-BY-SA-3.0 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="graphviz python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	dev-qt/qtbase:6[gui,network,opengl,widgets]
	dev-qt/qt5compat:6
	dev-qt/qtsvg:6
	>=dev-util/rizin-0.8.1:=
	graphviz? ( media-gfx/graphviz )
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="${DEPEND}
	!net-analyzer/cutter" # https://bugs.gentoo.org/897738
BDEPEND="dev-qt/qttools:6[linguist]"

PATCHES=(
	"${FILESDIR}/cutter-2.4.1-cmake4.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCUTTER_ENABLE_GRAPHVIZ="$(usex graphviz)"
		-DCUTTER_ENABLE_KSYNTAXHIGHLIGHTING=OFF
		-DCUTTER_ENABLE_PYTHON="$(usex python)"
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
