# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

WX_GTK_VER="3.0"

inherit check-reqs cmake-utils eapi7-ver eutils gnome2-utils python-single-r1 wxwidgets xdg

DESCRIPTION="Electronic Schematic and PCB design tools"
HOMEPAGE="http://www.kicad-pcb.org"
SRC_URI="https://launchpad.net/${PN}/$(ver_cut 1-2)/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-2+ GPL-3+ Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc examples github +ngspice +oce +python"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

COMMON_DEPEND=">=x11-libs/wxGTK-3.0.2:${WX_GTK_VER}[X,opengl]
	python? (
		dev-python/wxpython:${WX_GTK_VER}[opengl,${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
	>=dev-libs/boost-1.61[context,nls,threads,python?,${PYTHON_USEDEP}]
	github? (
		net-misc/curl[ssl]
	)
	media-libs/glew:0=
	media-libs/glm
	media-libs/freeglut
	media-libs/mesa
	ngspice? (
		sci-electronics/ngspice[shared]
	)
	oce? (
		sci-libs/oce
	)
	x11-libs/cairo"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	python? ( dev-lang/swig:0 )"
RDEPEND="${COMMON_DEPEND}
	sci-electronics/electronics-menu
"
CHECKREQS_DISK_BUILD="800M"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	setup-wxwidgets
	check-reqs_pkg_setup
}

src_prepare() {
	xdg_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DKICAD_DOCS="/usr/share/doc/${PF}"
		-DBUILD_GITHUB_PLUGIN="$(usex github)"
		-DKICAD_SCRIPTING="$(usex python)"
		-DKICAD_SCRIPTING_MODULES="$(usex python)"
		-DKICAD_SCRIPTING_WXPYTHON="$(usex python)"
		-DKICAD_SPICE="$(usex ngspice)"
		-DKICAD_USE_OCC=OFF
		-DKICAD_INSTALL_DEMOS="$(usex examples)"
	)
	use python && mycmakeargs+=(
		-DPYTHON_DEST="$(python_get_sitedir)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
	)
	use amd64 && use oce && mycmakeargs+=(
		-DKICAD_USE_OCE=ON
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		doxygen Doxyfile || die
	fi
}

src_install() {
	cmake-utils_src_install
	use python && python_optimize
	if use doc ; then
		dodoc uncrustify.cfg
		cd Documentation || die
		dodoc -r doxygen/.
	fi
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	optfeature "Component symbols library" sci-electronics/kicad-symbols
	optfeature "Component footprints library" sci-electronics/kicad-footprints
	optfeature "3D models of components " sci-electronics/kicad-packages3d
	optfeature "Project templates" sci-electronics/kicad-templates
	optfeature "Different languages for GUI" sci-electronics/kicad-i18n
	optfeature "Extended documentation" app-doc/kicad-doc
	optfeature "Creating 3D models of components" media-gfx/wings

	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
