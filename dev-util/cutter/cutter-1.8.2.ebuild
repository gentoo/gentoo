# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit qmake-utils xdg-utils python-single-r1

DESCRIPTION="A Qt and C++ GUI for radare2 reverse engineering framework"
HOMEPAGE="https://www.radare.org"
SRC_URI="https://github.com/radareorg/cutter/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jupyter webengine"
REQUIRED_USE="webengine? ( jupyter )
	${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	>=dev-qt/qtcore-5.9.1:5
	>=dev-qt/qtgui-5.9.1:5
	>=dev-qt/qtsvg-5.9.1:5
	>=dev-qt/qtwidgets-5.9.1:5
	dev-qt/qtnetwork:5
	>=dev-util/radare2-3.5.1
	jupyter? ( dev-python/jupyter )
	webengine? ( >=dev-qt/qtwebengine-5.9.1:5[widgets] )
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.8.0-python3-config.patch"
)

src_configure() {
	local myqmakeargs=(
		CUTTER_ENABLE_JUPYTER=$(usex jupyter true false)
		CUTTER_ENABLE_QTWEBENGINE=$(usex webengine true false)
		CUTTER_ENABLE_PYTHON=true
		PREFIX=\'${EPREFIX}/usr\'
	)

	eqmake5 "${myqmakeargs[@]}" src
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
