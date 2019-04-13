# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Can switch to EAPI=7 when wxwidgets eclass also supports it
EAPI=6
PYTHON_COMPAT=( python2_7 )

WX_GTK_VER="3.0"

inherit check-reqs cmake-utils eapi7-ver eutils gnome2-utils python-single-r1 toolchain-funcs wxwidgets xdg-utils

DESCRIPTION="Electronic Schematic and PCB design tools"
HOMEPAGE="http://www.kicad-pcb.org"
SRC_URI="https://launchpad.net/${PN}/5.0/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-2+ GPL-3+ Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc examples github +ngspice occ +oce openmp +python"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	?? ( occ oce )
"

COMMON_DEPEND=">=x11-libs/wxGTK-3.0.2:${WX_GTK_VER}[X,opengl]
	python? (
		dev-python/wxpython:${WX_GTK_VER}[opengl,${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
	>=dev-libs/boost-1.61[context,nls,threads,python?,${PYTHON_USEDEP}]
	github? ( net-misc/curl:=[ssl] )
	media-libs/glew:0=
	media-libs/glm
	media-libs/freeglut
	media-libs/mesa
	ngspice? (
		sci-electronics/ngspice[shared]
	)
	occ? ( >=sci-libs/opencascade-6.8.0:= )
	oce? ( sci-libs/oce )
	>=x11-libs/cairo-1.8.8:=
	>=x11-libs/pixman-0.30"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	python? ( >=dev-lang/swig-3.0:0 )"
RDEPEND="${COMMON_DEPEND}
	sci-electronics/electronics-menu
"
CHECKREQS_DISK_BUILD="800M"

PATCHES=(
	"${FILESDIR}"/"${PN}-5.1.0-help.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
	use openmp && tc-check-openmp
	setup-wxwidgets
	check-reqs_pkg_setup
}

src_configure() {
	xdg_environment_reset

	local mycmakeargs=(
		-DKICAD_DOCS="${EPREFIX}/usr/share/doc/${P}"
		-DKICAD_HELP="${EPREFIX}/usr/share/doc/${PN}-doc-${PV}"
		-DBUILD_GITHUB_PLUGIN="$(usex github)"
		-DKICAD_SCRIPTING="$(usex python)"
		-DKICAD_SCRIPTING_MODULES="$(usex python)"
		-DKICAD_SCRIPTING_WXPYTHON="$(usex python)"
		-DKICAD_SCRIPTING_ACTION_MENU="$(usex python)"
		-DKICAD_SPICE="$(usex ngspice)"
		-DKICAD_USE_OCC="$(usex occ)"
		-DKICAD_USE_OCE="$(usex oce)"
		-DKICAD_INSTALL_DEMOS="$(usex examples)"
	)
	use python && mycmakeargs+=(
		-DPYTHON_DEST="$(python_get_sitedir)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
	)
	use occ && mycmakeargs+=(
		-DOCC_INCLUDE_DIR="${CASROOT}"/include/opencascade
		-DOCC_LIBRARY_DIR="${CASROOT}"/lib
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		cmake-utils_src_compile dev-docs doxygen-docs
	fi
}

src_install() {
	cmake-utils_src_install
	use python && python_optimize
	if use doc ; then
		dodoc uncrustify.cfg
		cd Documentation || die
		dodoc -r *.txt kicad_doxygen_logo.png notes_about_pcbnew_new_file_format.odt doxygen/. development/doxygen/.
	fi
}

pkg_postinst() {
	optfeature "Component symbols library" sci-electronics/kicad-symbols
	optfeature "Component footprints library" sci-electronics/kicad-footprints
	optfeature "3D models of components " sci-electronics/kicad-packages3d
	optfeature "Project templates" sci-electronics/kicad-templates
	optfeature "Different languages for GUI" sci-electronics/kicad-i18n
	optfeature "Extended documentation" app-doc/kicad-doc
	optfeature "Creating 3D models of components" media-gfx/wings

	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
