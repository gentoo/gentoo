# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
WX_GTK_VER="3.0-gtk3"

inherit check-reqs cmake optfeature python-single-r1 toolchain-funcs wxwidgets xdg-utils

DESCRIPTION="Electronic Schematic and PCB design tools"
HOMEPAGE="https://www.kicad.org"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/code/kicad.git"
	inherit git-r3
else
	MY_PV="${PV/_rc/-rc}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://gitlab.com/kicad/code/${PN}/-/archive/${MY_PV}/${MY_P}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
	fi
fi

# BSD for bundled pybind
LICENSE="GPL-2+ GPL-3+ Boost-1.0 BSD"
SLOT="0"
IUSE="doc examples ngspice nls openmp +occ +pcm"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Contains bundled pybind but it's patched for wx
# See https://gitlab.com/kicad/code/kicad/-/commit/74e4370a9b146b21883d6a2d1df46c7a10bd0424
# Depend on opencascade:0 to get unslotted variant (so we know path to it), bug #833301
COMMON_DEPEND="
	!sci-electronics/kicad-i18n
	dev-libs/boost:=[context,nls]
	media-libs/freeglut
	media-libs/glew:0=
	>=media-libs/glm-0.9.9.1
	media-libs/mesa[X(+)]
	>=x11-libs/cairo-1.8.8:=
	>=x11-libs/pixman-0.30
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	$(python_gen_cond_dep '
		dev-libs/boost:=[context,nls,python,${PYTHON_USEDEP}]
		dev-python/wxpython:4.0[${PYTHON_USEDEP}]
	')
	${PYTHON_DEPS}
	ngspice? (
		>sci-electronics/ngspice-27[shared]
	)
	nls? (
		sys-devel/gettext
	)
	occ? (
		>=sci-libs/opencascade-7.3.0:0=
	)
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	sci-electronics/electronics-menu
"
BDEPEND=">=dev-lang/swig-3.0
	doc? ( app-doc/doxygen )"

if [[ ${PV} == 9999 ]] ; then
	# x11-misc-util/macros only required on live ebuilds
	BDEPEND+=" >=x11-misc/util-macros-1.18"
fi

CHECKREQS_DISK_BUILD="900M"

PATCHES=(
	"${FILESDIR}/${PN}-scripts-install-fix.patch"
	"${FILESDIR}/${PN}-6.0.6-unitialized-variable-fix.patch"
)

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	python-single-r1_pkg_setup
	setup-wxwidgets
	check-reqs_pkg_setup
}

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		default_src_unpack
	fi
}

src_configure() {
	xdg_environment_reset

	local mycmakeargs=(
		-DKICAD_DOCS="${EPREFIX}/usr/share/doc/${PN}-doc-${PV}"

		-DKICAD_SCRIPTING_WXPYTHON=ON

		# Merged from separate -i18n package, bug #830274
		-DKICAD_BUILD_I18N="$(usex nls)"
		-DKICAD_I18N_UNIX_STRICT_PATH="$(usex nls)"

		-DPYTHON_DEST="$(python_get_sitedir)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"

		-DKICAD_SPICE="$(usex ngspice)"
		-DKICAD_PCM="$(usex pcm)"

		-DKICAD_USE_OCC="$(usex occ)"
		-DKICAD_INSTALL_DEMOS="$(usex examples)"
		-DCMAKE_SKIP_RPATH="ON"
	)

	use occ && mycmakeargs+=(
		-DOCC_INCLUDE_DIR="${CASROOT}"/include/opencascade
		-DOCC_LIBRARY_DIR="${CASROOT}"/$(get_libdir)/opencascade
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		cmake_src_compile doxygen-docs
	fi
}

src_test() {
	# Test cannot find library in Portage's sandbox. Let's create a link so test can run.
	ln -s "${BUILD_DIR}/eeschema/_eeschema.kiface" "${BUILD_DIR}/qa/eeschema/_eeschema.kiface" || die

	# LD_LIBRARY_PATH is there to help it pick up the just-built libraries
	LD_LIBRARY_PATH="${BUILD_DIR}/3d-viewer/3d_cache/sg:${LD_LIBRARY_PATH}" cmake_src_test
}

src_install() {
	cmake_src_install
	python_optimize

	if use doc ; then
		dodoc uncrustify.cfg
		cd Documentation || die
		dodoc -r *.txt kicad_doxygen_logo.png notes_about_pcbnew_new_file_format.odt doxygen/.
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
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
