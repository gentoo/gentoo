# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
WX_GTK_VER="3.2-gtk3"

inherit check-reqs cmake flag-o-matic optfeature python-single-r1 toolchain-funcs wxwidgets xdg-utils

DESCRIPTION="Electronic Schematic and PCB design tools"
HOMEPAGE="https://www.kicad.org"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/code/kicad.git"
	inherit git-r3
else
	MY_PV="${PV/_rc/-rc}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://gitlab.com/kicad/code/${PN}/-/archive/${MY_PV}/${MY_P}.tar.bz2"
	SRC_URI+="
		https://gitlab.com/kicad/code/kicad/-/commit/5774338af2e22e1ff541ad9ab368e459e2a2add2.patch -> ${PN}-9.0.0-protobuf-30.patch
	"
	S="${WORKDIR}/${MY_P}"

	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~amd64"
	fi
fi

# KiCAD is licensed under GPLv3 or later
# As per LICENSES.README some components are under different, but GPL compatible license:
# Licensed under Apache License, Version 2.0: portions of code in libs/kimath/include/math/util.h
# Licensed under BOOSTv1: clipper, clipper2, libcontext, pegtl, picosha2, turtle
# Licensed under ISC: portions of code in include/geometry/polygon_triangulation.h
# Licensed under MIT: argparse, compoundfilereader, delaunator, fmt, json_schema_validator, magic_enum nanodbc,
#                     nlohmann/json, nlohmann/fifo_map, pboettch/json-schema-validator, picoSHA2, rectpack2d,
#                     sentry-native, thread-pool, tinyspline_lib
# Licensed under MIT and BSD: glew
# Licensed under BSD: pybind11
# Licensed under BSD2: gzip-hpp
# Licensed under GPLv2 (or later): dxflib, math_for_graphics, potrace,
#                                  SutherlandHodgmanClipPoly in thirdparty/other_math
# Licensed under ZLib: nanosvg
# Licensed in the public domain: lemon
# Licensed under CC BY-SA 4.0: all the demo files provided in demos/*
# Licensed under clause-3 BSD: ibis/kibis files in eeschema/sim/kibis
# Licensed under CC0: uopamp.lib.spice in some directories in qa/data/eeschema/spice_netlists/
LICENSE="GPL-2+ GPL-3+ Boost-1.0 BSD BSD-2 Apache-2.0 ISC MIT ZLIB CC-BY-SA-4.0 CC0-1.0"
SLOT="0"
IUSE="doc examples nls openmp test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

# Contains bundled pybind but it's patched for wx
# See https://gitlab.com/kicad/code/kicad/-/commit/74e4370a9b146b21883d6a2d1df46c7a10bd0424
# Depend on opencascade:0 to get unslotted variant (so we know path to it), bug #833301
# Depend wxGTK version needs to be limited due to switch from EGL to GLX, bug #911120
COMMON_DEPEND="
	app-crypt/libsecret
	dev-db/unixODBC
	dev-libs/boost:=[context,nls]
	dev-libs/libgit2:=
	>=dev-libs/protobuf-27.2:=[protobuf,protoc]
	>=dev-libs/nng-1.10.0:=
	media-libs/freeglut
	media-libs/glew:0=
	>=media-libs/glm-0.9.9.1
	media-libs/mesa[X(+)]
	net-misc/curl
	>=sci-libs/opencascade-7.5.0:0=
	>=x11-libs/cairo-1.8.8:=
	>=x11-libs/pixman-0.30
	>sci-electronics/ngspice-27[shared]
	sys-libs/zlib
	>=x11-libs/wxGTK-3.2.2.1-r3:${WX_GTK_VER}[X,opengl]
	$(python_gen_cond_dep '
		dev-libs/boost:=[context,nls,python,${PYTHON_USEDEP}]
		>=dev-python/wxpython-4.2.0:*[${PYTHON_USEDEP}]
	')
	${PYTHON_DEPS}
	nls? (
		sys-devel/gettext
	)
	test? (
		media-gfx/cairosvg
	)
"

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	sci-electronics/electronics-menu
"
BDEPEND=">=dev-lang/swig-4.0
	doc? ( app-text/doxygen )"

if [[ ${PV} == 9999 ]] ; then
	# x11-misc-util/macros only required on live ebuilds
	BDEPEND+=" >=x11-misc/util-macros-1.18"
fi

CHECKREQS_DISK_BUILD="1500M"

PATCHES=(
	"${DISTDIR}/${P}-protobuf-30.patch" # drop in 9.0.1
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

src_prepare() {
	filter-lto # Bug 927482
	cmake_src_prepare
}

src_configure() {
	xdg_environment_reset

	local mycmakeargs=(
		-DKICAD_DOCS="${EPREFIX}/usr/share/doc/${PN}-doc-${PV}"

		-DKICAD_SCRIPTING_WXPYTHON=ON
		-DKICAD_USE_EGL=OFF

		-DKICAD_BUILD_I18N="$(usex nls)"
		-DKICAD_I18N_UNIX_STRICT_PATH="$(usex nls)"

		-DPYTHON_DEST="$(python_get_sitedir)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"

		-DKICAD_INSTALL_DEMOS="$(usex examples)"
		-DCMAKE_SKIP_RPATH="ON"

		-DOCC_INCLUDE_DIR="${CASROOT}"/include/opencascade
		-DOCC_LIBRARY_DIR="${CASROOT}"/$(get_libdir)/opencascade

		-DKICAD_SPICE_QA="$(usex test)"
		-DKICAD_BUILD_QA_TESTS="$(usex test)"
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
	mkdir -p "${BUILD_DIR}/qa/eeschema/" || die
	ln -s "${BUILD_DIR}/eeschema/_eeschema.kiface" "${BUILD_DIR}/qa/eeschema/_eeschema.kiface" || die

	export CMAKE_SKIP_TESTS=(
		qa_pcbnew
		qa_cli
	)

	# LD_LIBRARY_PATH is there to help it pick up the just-built libraries
	LD_LIBRARY_PATH="${BUILD_DIR}/common:${BUILD_DIR}/common/gal:${BUILD_DIR}/3d-viewer/3d_cache/sg:${LD_LIBRARY_PATH}" \
		cmake_src_test
}

src_install() {
	cmake_src_install
	python_optimize

	dodoc doxygen/eagle-plugin-notes.txt

	if use doc ; then
		cd doxygen || die
		dodoc -r out/html/.
	fi
}

pkg_postinst() {
	optfeature "Component symbols library" sci-electronics/kicad-symbols
	optfeature "Component footprints library" sci-electronics/kicad-footprints
	optfeature "3D models of components " sci-electronics/kicad-packages3d
	optfeature "Project templates" sci-electronics/kicad-templates
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
