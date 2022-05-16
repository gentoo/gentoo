# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9} )

WX_GTK_VER="3.0-gtk3"

inherit check-reqs cmake optfeature python-single-r1 toolchain-funcs wxwidgets xdg-utils

DESCRIPTION="Electronic Schematic and PCB design tools"
HOMEPAGE="https://www.kicad.org"
SRC_URI="https://gitlab.com/kicad/code/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+ GPL-3+ Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc examples github +ngspice +occ openmp +python"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"
# Depend on opencascade:0 to get unslotted variant (so we know path to it), bug #833301
COMMON_DEPEND="
	>=dev-libs/boost-1.61:=[context,nls,threads(+)]
	media-libs/freeglut
	media-libs/glew:0=
	>=media-libs/glm-0.9.9.1
	media-libs/mesa[X(+)]
	>=x11-libs/cairo-1.8.8:=
	>=x11-libs/pixman-0.30
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	github? ( net-misc/curl:=[ssl] )
	ngspice? (
		>sci-electronics/ngspice-27[shared]
	)
	occ? ( <sci-libs/opencascade-7.5.3:0=[vtk(+)] )
	python? (
		$(python_gen_cond_dep '
			>=dev-libs/boost-1.61:=[context,nls,threads(+),python,${PYTHON_USEDEP}]
			dev-python/wxpython:4.0[${PYTHON_USEDEP}]
		')
		${PYTHON_DEPS}
	)
"
DEPEND="${COMMON_DEPEND}
	python? ( >=dev-lang/swig-3.0:0 )"
RDEPEND="${COMMON_DEPEND}
	sci-electronics/electronics-menu
"
BDEPEND="doc? ( app-doc/doxygen )"
CHECKREQS_DISK_BUILD="800M"

PATCHES=(
	"${FILESDIR}/${PN}-5.1.5-help.patch"
	"${FILESDIR}/${PN}-5.1.5-strict-aliasing.patch"
	"${FILESDIR}/${PN}-5.1.6-metainfo.patch"
	"${FILESDIR}/${PN}-5.1.5-ldflags.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	use python && python-single-r1_pkg_setup
	setup-wxwidgets
	check-reqs_pkg_setup
}

src_unpack() {
	default_src_unpack
	# For the metainfo patch to work the kicad.appdata.xml has to be moved to
	# avoid QA issue.  This is needed because /usr/share/appdata location is
	# deprecated, it should not be used anymore by new software.
	# Appdata/Metainfo files should be installed into /usr/share/metainfo
	# directory. as per
	# https://www.freedesktop.org/software/appstream/docs/chap-Metadata.html
	mv "${S}/resources/linux/appdata" "${S}/resources/linux/metainfo" || die "Appdata move failed"
}

src_prepare() {
	# Fix OpenCASCADE lookup
	sed -e 's|/usr/include/opencascade|${CASROOT}/include/opencascade|' \
		-e 's|/usr/lib|${CASROOT}/'$(get_libdir)' NO_DEFAULT_PATH|' \
		-i CMakeModules/FindOpenCASCADE.cmake || die

	cmake_src_prepare
}

src_configure() {
	xdg_environment_reset

	local mycmakeargs=(
		-DKICAD_DOCS="${EPREFIX}/usr/share/doc/${PF}"
		-DKICAD_HELP="${EPREFIX}/usr/share/doc/${PN}-doc-${PV}"
		-DBUILD_GITHUB_PLUGIN="$(usex github)"
		-DKICAD_SCRIPTING="$(usex python)"
		-DKICAD_SCRIPTING_MODULES="$(usex python)"
		-DKICAD_SCRIPTING_WXPYTHON="$(usex python)"
		-DKICAD_SCRIPTING_WXPYTHON_PHOENIX="$(usex python)"
		-DKICAD_SCRIPTING_PYTHON3="$(usex python)"
		-DKICAD_SCRIPTING_ACTION_MENU="$(usex python)"
		-DKICAD_SPICE="$(usex ngspice)"
		-DKICAD_USE_OCC="$(usex occ)"
		-DKICAD_INSTALL_DEMOS="$(usex examples)"
		-DCMAKE_SKIP_RPATH="ON"
	)
	use python && mycmakeargs+=(
		-DPYTHON_DEST="$(python_get_sitedir)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
	)
	if use occ; then
		mycmakeargs+=(
			-DOCC_INCLUDE_DIR="${CASROOT}"/include/opencascade
			-DOCC_LIBRARY_DIR="${CASROOT}"/$(get_libdir)/opencascade
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		cmake_src_compile dev-docs doxygen-docs
	fi
}

src_install() {
	cmake_src_install
	use python && python_optimize
	if use doc ; then
		dodoc uncrustify.cfg
		cd Documentation || die
		dodoc -r *.txt kicad_doxygen_logo.png notes_about_pcbnew_new_file_format.odt doxygen/. development/doxygen/.
	fi
}

src_test() {
	# Test cannot find library in Portage's sandbox. Let's create a link so test can run.
	ln -s "${S}_build/eeschema/_eeschema.kiface" "${S}_build/qa/eeschema/_eeschema.kiface" || die

	default
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
