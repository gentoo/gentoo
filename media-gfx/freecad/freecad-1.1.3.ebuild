# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

# https://github.com/FreeCAD/FreeCAD/issues/19066
# The added asserts break on mem leaks, so tests fail.
# PYTHON_REQ_USE="-debug"

# pyNastran missing

inherit branding check-reqs cmake cuda edo flag-o-matic optfeature python-single-r1 toolchain-funcs xdg virtualx

DESCRIPTION="Qt based Computer Aided Design application"
HOMEPAGE="https://www.freecad.org/ https://github.com/FreeCAD/FreeCAD"

MY_PN=FreeCAD

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${MY_PN}/${MY_PN}.git"
	EGIT_SUBMODULES=( '-*' )
else
	SRC_URI="
		https://github.com/${MY_PN}/${MY_PN}/releases/download/${PV}/freecad_source_${PV}.tar.gz
	"
	KEYWORDS="~amd64"
fi

# code is licensed LGPL-2
# examples are licensed CC-BY-SA (without note of specific version)
LICENSE="LGPL-2 CC-BY-SA-4.0"
SLOT="0"
IUSE="debug designer +gui netgen pcl +smesh spacenav tbb test X"
# Modules are found in src/Mod/ and their options defined in:
# cMake/FreeCAD_Helpers/InitializeFreeCADBuildOptions.cmake
# To get their dependencies:
# 'grep REQUIRES_MODS cMake/FreeCAD_Helpers/CheckInterModuleDependencies.cmake'
IUSE+=" addonmgr assembly +bim cam fem idf inspection +mesh openscad points reverse robot surface +techdraw"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	bim? ( mesh )
	cam? ( mesh )
	gui? ( bim )
	designer? ( gui )
	fem? ( smesh )
	inspection? ( points )
	mesh? ( smesh )
	openscad? ( mesh )
	reverse? ( mesh points )
	test? ( techdraw )
"
# Draft Workbench needs BIM

RESTRICT="!test? ( test )"

# if opencascade[tbb], we link to tbb
# if vtk[cuda], we use cuda
RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/yaml-cpp:=
	dev-libs/boost:=
	dev-libs/libfmt:=
	dev-libs/xerces-c:=[icu]
	dev-qt/qtbase:6[concurrent,network,xml]
	media-libs/freetype
	sci-libs/opencascade:=[json,tbb?]
	tbb? (
		dev-cpp/tbb:=
	)
	virtual/zlib:=
	$(python_gen_cond_dep '
		dev-python/lark[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		>=dev-python/pybind11-3.0.1[${PYTHON_USEDEP}]
		dev-python/pycxx[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	assembly? ( >=sci-libs/ondselsolver-1.0.1_p20260211 )
	fem? (
		sci-libs/vtk:=
		$(python_gen_cond_dep 'dev-python/ply[${PYTHON_USEDEP}]')
	)
	gui? (
		>=media-libs/coin-4.0.0
		dev-qt/qtbase:6[gui,opengl,widgets]
		dev-qt/qtsvg:6
		dev-qt/qttools:6[designer?,widgets]
		$(python_gen_cond_dep '
			dev-python/matplotlib[${PYTHON_USEDEP}]
			>=dev-python/pivy-0.6.5[${PYTHON_USEDEP}]
			dev-python/pyside:6=[uitools(-),gui,svg,${PYTHON_USEDEP}]
		' )
		virtual/opengl
		spacenav? ( dev-libs/libspnav[X?] )
	)
	netgen? ( <media-gfx/netgen-6.2.2605[opencascade] )
	openscad? ( $(python_gen_cond_dep 'dev-python/ply[${PYTHON_USEDEP}]') )
	pcl? ( sci-libs/pcl:= )
	smesh? (
		>=sci-libs/med-4.0.0-r1
		sci-libs/vtk:=
	)
"
# TODO why?
RDEPEND+="
	dev-libs/icu:=
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:=
	dev-cpp/ms-gsl
	test? (
		$(python_gen_impl_dep '-debug')
		$(python_gen_cond_dep '
			sci-libs/vtk[python,${PYTHON_SINGLE_USEDEP}]
		' )
		fem? (
			sci-libs/calculix-ccx
			$(python_gen_cond_dep '
				sci-libs/gmsh[${PYTHON_USEDEP}]
			' )
		)
		gui? (
			$(python_gen_cond_dep '
				dev-python/pyside:6[tools(-),${PYTHON_USEDEP}]
			' )
		)
		dev-cpp/gtest
	)
"
BDEPEND="
	dev-lang/swig
	test? (
		gui? (
			$(python_gen_cond_dep '
				dev-python/pytest[${PYTHON_USEDEP}]
				dev-python/typing-extensions[${PYTHON_USEDEP}]
			' )
		)
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.3-Gentoo-specific-don-t-check-vcs.patch"
	"${FILESDIR}/${PN}-1.1.1-tests-src-Qt-only-build-test-for-BUILD_GUI-ON.patch"
	"${FILESDIR}/${PN}-1.1.3-fastsignals-disconnect.patch"
	"${FILESDIR}/${PN}-1.1.1-fix-sketcher-toolbars.patch"
	"${FILESDIR}/${PN}-1.1.0-boost_system.patch"
	"${FILESDIR}/${PN}-1.1.3-fix-COIN3D_MICRO_VERSION-regex-for-coin-4.0.10.patch"
	"${FILESDIR}/${PN}-1.1.3-gcc-17-fstream.patch"
	"${FILESDIR}/${PN}-1.1.3-skip-unicode-test.patch"
)

DOCS=( CODE_OF_CONDUCT.md README.md )

CHECKREQS_DISK_BUILD="2G"

cuda_get_host_compiler() {
	if [[ -v NVCC_CCBIN ]]; then
		echo "${NVCC_CCBIN}"
		return
	fi

	if [[ -v CUDAHOSTCXX ]]; then
		echo "${CUDAHOSTCXX}"
		return
	fi

	if ! command -v nvcc >/dev/null; then
		eerror "Could not find nvcc. Is the CUDA SDK installed?"
		die "nvcc not found"
	fi

	einfo "Trying to find working CUDA host compiler"

	if ! tc-is-gcc && ! tc-is-clang; then
		die "$(tc-get-compiler-type) compiler is not supported"
	fi

	# compiler with CHOST prefix
	# x86_64-pc-linux-gnu-g++
	local compiler

	# gcc or clang
	local compiler_type

	# major version of the current compiler. 15
	local compiler_version

	# cat/pkg of the compiler
	# sys-devel/gcc, llvm-core/clang
	local package

	# QPN of the package we are checking
	# sys-devel/gcc, <sys-devel/gcc-15
	local package_version

	# system compiler e.g. tc-getCXX plus version
	# used to skip rechecking, as we check NVCC_CCBIN first
	# x86_64-pc-linux-gnu-g++-15
	local NVCC_CCBIN_default

	compiler_type="$(tc-get-compiler-type)"
	compiler_version="$("${compiler_type}-major-version")"

	# try the default compiler first
	NVCC_CCBIN="$(tc-getCXX)"
	NVCC_CCBIN_default="${NVCC_CCBIN}-${compiler_version}"

	compiler="${NVCC_CCBIN/%-${compiler_version}}"

	# store the package so we can re-use it later
	if tc-is-gcc; then
		package="sys-devel/${compiler_type}"
	elif tc-is-clang; then
		package="llvm-core/${compiler_type}"
	else
		die "$(tc-get-compiler-type) compiler is not supported"
	fi

	package_version="${package}"

	ebegin "testing ${NVCC_CCBIN_default} (default)"

	while ! \
		nvcc "${NVCCFLAGS:-}" \
			-ccbin "${NVCC_CCBIN}" \
			- \
			-x cu \
			<<<"int main(){}" \
			&>> "${T:?}/cuda_get_host_compiler.log" ;
		do
		eend 1

		while true; do
			# prepare next version
			local package_version_next
			package_version_next="$(best_version "${package_version}")"

			if [[ -z "${package_version_next}" ]]; then
				eerror "Compiler lookup failed. Nothing installed matches: ${package_version}."
				eerror "You can use NVCC_CCBIN to specify the exact compiler to use."
				eerror "Check ${T}/cuda_get_host_compiler.log for details."
				die "Could not find a supported version of ${compiler}. Did not find \"${package_version}\". NVCC_CCBIN is unset."
			fi

			package_version="<${package_version_next}"

			NVCC_CCBIN="${compiler}-$(ver_cut 1 "${package_version/#<${package}-/}")"

			# skip the next version equals the already checked system default
			[[ "${NVCC_CCBIN}" != "${NVCC_CCBIN_default}" ]] && break
		done
		ebegin "testing ${NVCC_CCBIN}"
	done
	eend $?

	echo "${NVCC_CCBIN}"
	export NVCC_CCBIN
}

pkg_setup() {
	check-reqs_pkg_setup
	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		# only fetch/unpack if used
		if use addonmgr; then
			EGIT_SUBMODULES+=( 'src/Mod/AddonManager' )
		fi

		git-r3_src_unpack
	else
		# release archive does not contain a top-level directory...
		mkdir -p "${S}" || die
		cd "${S}" || die
		unpack ${A}
	fi
}

src_prepare() {
	sed \
		-e '/include( ccache )/s/^/# /g' \
		-e '/include( ClangFormat )/s/^/# /g' \
		-i src/3rdParty/libE57Format/CMakeLists.txt || die

	# TODO
	sed -e '/TestExternalFacePreselection/d' -i src/Mod/Sketcher/TestSketcherGui.py || die

	# removed bundled pycxx
	if [[ ${PV} != *9999* ]]; then
		rm -r src/3rdParty/PyCXX || die "remove bundled pycxx"
	fi

	cmake_src_prepare
}

src_configure() {
	# -Werror=odr, -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/875221
	# https://github.com/FreeCAD/FreeCAD/issues/13173
	append-flags -fno-strict-aliasing
	filter-lto

	# Fix building tests
	if tc-ld-is-bfd; then # 940524
		append-ldflags -Wl,--copy-dt-needed-entries
	fi

	local mycmakeargs=(
		"$(cmake_use_find_package "spacenav" "Spnav")"

		-DPYCXX_INCLUDE_DIRS="${ESYSROOT}/usr/include/${PYTHON_SINGLE_TARGET/_/.}"
		-DPYCXX_SOURCE_DIR="${ESYSROOT}/usr/share/${PYTHON_SINGLE_TARGET/_/.}/CXX"

		-DBUILD_DESIGNER_PLUGIN=$(usex designer)
		-DBUILD_FORCE_DIRECTORY=ON				# force building in a dedicated directory
		-DBUILD_GUI=$(usex gui)
		-DBUILD_SMESH=$(usex smesh)
		-DBUILD_VR=OFF
		-DBUILD_WITH_CONDA=OFF

		# Modules
		-DBUILD_ADDONMGR=$(usex addonmgr)
		-DBUILD_ASSEMBLY=$(usex assembly)
		-DBUILD_BIM=$(usex bim)
		-DBUILD_CAM=$(usex cam)
		-DBUILD_DRAFT=ON
		# see below for DRAWING
		-DBUILD_FEM=$(usex fem)
		-DBUILD_FEM_NETGEN=$(usex fem $(usex netgen))
		-DBUILD_FLAT_MESH=$(usex mesh)			# a submodule of MeshPart
		-DBUILD_HELP=ON
		-DBUILD_IDF=$(usex idf)
		-DBUILD_IMPORT=ON						# import module for various file formats
		-DBUILD_INSPECTION=$(usex inspection)
		-DBUILD_JTREADER=OFF					# uses an old proprietary library
		-DBUILD_MATERIAL=ON
		-DBUILD_MATERIAL_EXTERNAL=ON
		-DBUILD_MEASURE=ON
		-DBUILD_MESH=$(usex mesh)
		-DBUILD_MESH_PART=$(usex mesh)
		-DBUILD_OPENSCAD=$(usex openscad)
		-DBUILD_PART=ON
		-DBUILD_PART_DESIGN=ON
		-DBUILD_PLOT=ON
		-DBUILD_POINTS=$(usex points)
		-DBUILD_REVERSEENGINEERING=$(usex reverse)
		-DBUILD_ROBOT=$(usex robot)
		# -DBUILD_SANDBOX=OFF
		-DBUILD_SHOW=$(usex gui)
		-DBUILD_SKETCHER=ON						# needed by draft workspace
		-DBUILD_SPREADSHEET=ON
		-DBUILD_START=ON
		-DBUILD_SURFACE=$(usex surface)
		-DBUILD_TECHDRAW=$(usex techdraw)
		-DBUILD_TEST="$(usex test)"				# always build test workbench for run-time testing
		-DBUILD_TUX=$(usex gui)
		-DBUILD_WEB=ON							# needed by start workspace

		# do not set these or tests fail
		# -DCMAKE_INSTALL_DATADIR=share/${PN}/data
		# -DCMAKE_INSTALL_DOCDIR=share/doc/${PF}
		# -DCMAKE_INSTALL_INCLUDEDIR=include/${PN}
		# -DCMAKE_INSTALL_PREFIX=/usr/$(get_libdir)/${PN}
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/$(get_libdir)/${PN}"

		-DFREECAD_BUILD_DEBIAN=OFF

		-DE57_ENABLE_DIAGNOSTIC_OUTPUT="no"
		-DE57_VALIDATION_LEVEL=0

		# -DFREECAD_PARALLEL_COMPILE_JOBS=""
		# -DFREECAD_PARALLEL_LINK_JOBS=""

		-DFREECAD_USE_3DCONNEXION_LEGACY="no"
		-DFREECAD_USE_CCACHE="no" # Do not use CCache

		-DFREECAD_USE_EXTERNAL_CLIPPER2="yes"
		-DFREECAD_USE_EXTERNAL_COIN_PIVY="yes"
		-DFREECAD_USE_EXTERNAL_E57FORMAT="no"
		-DFREECAD_USE_EXTERNAL_GTEST="$(usex test)"
		-DFREECAD_USE_EXTERNAL_JSON="yes"
		-DFREECAD_USE_EXTERNAL_KDL=OFF # https://github.com/FreeCAD/FreeCAD/commit/9f98866
		-DFREECAD_USE_EXTERNAL_KDTREE=OFF
		-DFREECAD_USE_EXTERNAL_ONDSELSOLVER=$(usex assembly)
		-DFREECAD_USE_EXTERNAL_PYCXX="no"
		-DFREECAD_USE_EXTERNAL_SMESH=OFF		# no package in Gentoo
		-DFREECAD_USE_EXTERNAL_ZIPIOS=OFF		# doesn't work yet, also no package in Gentoo tree

		-DFREECAD_USE_FREETYPE=ON
		-Dfreetype_DIR="${ESYSROOT}/usr"
		-DFREECAD_USE_OCC_VARIANT:STRING="Official Version"
		-DFREECAD_USE_PCL=$(usex pcl)
		# -DFREECAD_USE_PYBIND11=ON
		-DFREECAD_USE_PYSIDE="yes"
		-DFREECAD_USE_QT_DIALOGS="yes"
		# -DFREECAD_USE_QT_FILEDIALOG=ON
		-DFREECAD_USE_SHIBOKEN="yes"

		# install python modules to site-packages' dir. True only for the main package,
		# sub-packages will still be installed inside /usr/lib64/freecad
		-DINSTALL_TO_SITEPACKAGES=ON

		# Use the version of pyside[tools] that matches the selected python version
		-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
		# -DPython3_EXECUTABLE=${EPYTHON}
	)

	if [[ ${PV} == *9999* ]]; then
		mycmakeargs+=(
			-DENABLE_DEVELOPER_TESTS="$(usex test)"

			-DPACKAGE_WCREF="%{release} (Git)"
			-DPACKAGE_WCURL="git://github.com/FreeCAD/FreeCAD.git main"
		)
	else
		mycmakeargs+=(
			-DENABLE_DEVELOPER_TESTS=OFF

			-DPACKAGE_WCREF="${PVR} (${BRANDING_OS_NAME})"
			-DPACKAGE_WCURL="git://github.com/FreeCAD/FreeCAD.git ${PV}"
		)
	fi

	if use debug; then
		# BUILD_SANDBOX currently broken, see
		# https://forum.freecadweb.org/viewtopic.php?f=4&t=36071&start=30#p504595
		mycmakeargs+=(
			-DBUILD_SANDBOX=OFF
			-DBUILD_TEMPLATE=ON
		)
	else
		mycmakeargs+=(
			-DBUILD_SANDBOX=OFF
			-DBUILD_TEMPLATE=OFF
		)
	fi

	# fem and smesh depend on sci-lib/vtk, which looks up a cuda compiler when build with USE=cuda.
	# We therefore need to set the correct CUDAHOSTCXX and setup the sandbox.
	if use fem || use smesh; then
		if has_version "sci-libs/vtk[cuda]" ; then
			cuda_add_sandbox
			addpredict "/dev/char/"
			export CUDAHOSTCXX="$(cuda_get_host_compiler)"
		fi
	fi

	if use gui; then
		mycmakeargs+=(
			-DFREECAD_QT_MAJOR_VERSION=6
			-DFREECAD_QT_VERSION=6
			-DQT_DEFAULT_MAJOR_VERSION=6
			-DBUILD_QT5=OFF
			# Drawing module unmaintained and not ported to qt6
			-DBUILD_DRAWING=OFF
		)
	fi

	cmake_src_configure
}

# We use the FreeCADCmd binary instead of the FreeCAD binary here
# for two reasons:
# 1. It works out of the box with USE=-gui as well, not needing a guard
# 2. We don't need virtualx.eclass and its dependencies
src_test() {
	# Fails because translated names are used otherwise
	local -x LANG="en_US.UTF-8"

	# The environment variables are needed, so that FreeCAD knows
	# where to save its temporary files, and where to look and write its
	# configuration. Without those, there is a sandbox violation, when it
	# tries to create /var/lib/portage/home/.FreeCAD directory.
	local -x FREECAD_USER_HOME="${T}/home"
	local -x FREECAD_USER_DATA="${T}/data"
	local -x FREECAD_USER_TEMP="${T}/temp"

	mkdir -p "${FREECAD_USER_HOME}" "${FREECAD_USER_DATA}" "${FREECAD_USER_TEMP}" || die

	cd "${BUILD_DIR}" || die

	if use bim; then
		# No module named 'ifcopenshell' #940465
		rm "Mod/BIM/nativeifc/ifc_performance_test.py" || die
	fi

	if use cam; then
		# we need the spaces to match the python indent
		sed -e '/test46/a \        return' -i "Mod/CAM/CAMTests/TestPathOpUtil.py" || die
		sed -e '/test47/a \        return' -i "Mod/CAM/CAMTests/TestPathOpUtil.py" || die
	fi

	if ! use openscad ; then
		EPYTEST_IGNORE+=(
			"Mod/OpenSCAD/OpenSCADTest/app/test_importCSG.py"
			"Mod/OpenSCAD/OpenSCADTest/gui/test_dummy.py"
		)
	fi

	# # TODO coin? pivy?
	# sed \
	# 	-e '/self.assertTrue(pc.getTriangleCount/i \        print(pc.getTriangleCount())' \
	# 	-e '/self.assertTrue(pc.getTriangleCount/s/self/# /' \
	# 	-i Mod/Mesh/MeshTestsApp.py || die

	local -x EPYTEST_IGNORE=(
		"Mod/BIM/nativeifc/ifc_performance_test.py"
	)

	local CMAKE_SKIP_TESTS=(
		"^TestLineFormat.setQColorKeepsOpaqueColorsOpaque$"
		"^TestLineFormat.setQColorPreservesAlphaValue$"
	)

	local failed=()

	run_freecad() {
		if [[ $# -ne 1 && $# -ne 2  ]]; then
			eerror "$0: usage <cmd> [<runner>]"
			die "$0: usage <cmd> <runner>"
		fi

		local cmd="${1}"
		local run="${2}"

		if use debug; then
			nonfatal \
			${run} \
			edo \
			"${BUILD_DIR}/bin/${cmd}" \
				--set-config AppHomePath="${BUILD_DIR}/" \
				--dump-config &> "${T}/${cmd}_config.log"
		fi

		if \
			! nonfatal \
			${run} \
			edo \
			"${BUILD_DIR}/bin/${cmd}" \
				--run-test 0 \
				--set-config AppHomePath="${BUILD_DIR}/" \
				--log-file "${T}/${cmd}.log"
		then
			ret=$?
			eerror "${cmd} failed ${ret}"
			die "${cmd} failed ${ret}"
			failed+=( "${cmd}" )
		fi
	}

	if ! use gui; then
		run_freecad "FreeCADCmd"
	else
		run="virtx"

		addwrite "/dev/dri/renderD128"
		addwrite "/dev/dri/card0"

		[[ -c "/dev/udmabuf" ]] && addwrite "/dev/udmabuf"

		if [[ -c "/dev/nvidiactl" ]]; then
			addwrite "/dev/nvidiactl"
			addpredict "/dev/char/"
			[[ -c "/dev/nvidia-uvm" ]] && addwrite "/dev/nvidia-uvm"
			[[ -c "/dev/nvidia-uvm-tools" ]] && addwrite "/dev/nvidia-uvm-tools"
			[[ -c "/dev/nvidia0" ]] && addwrite "/dev/nvidia0"
		fi

		# run_freecad "FreeCAD" virtx

		# this runs only the gui tests
		if \
			! nonfatal \
				virtx \
				${PYTHON} "${S}/.github/scripts/run_gui_tests.py" "${BUILD_DIR}"
		then
			ret=$?
			eerror "$run_gui_tests.py failed ${ret}"
			die "run_gui_tests.py failed ${ret}"
			failed+=( "run_gui_tests.py" )
		fi
	fi

	if [[ ${PV} == *9999* ]]; then
		local myctestargs=(
			# for YamlParameterSourceTest
			-j1
		)
		if ! nonfatal \
			${run} \
			cmake_src_test
		then
			ret=$?
			eerror "cmake_src_test failed ${ret}"
			die "cmake_src_test failed ${ret}"
			failed+=( "cmake_src_test" )
		fi
	fi

	if [[ "${#failed[@]}" -gt 0 ]]; then
		eerror "Tests ${failed[*]} failed"
		# Tests _will_ fail with USE=debug as the reference values change
		# We want test failures to be fatal for keyworded versions
		if ! use debug || [[ ${PV} != *9999* ]]; then
			die "${failed[@]}"
		fi
	fi
}

src_install() {
	cmake_src_install

	if use gui; then
		newbin - FreeCAD <<- _EOF_
			#!/usr/bin/env sh
			# https://github.com/coin3d/coin/issues/451
			: "\${QT_QPA_PLATFORM:=xcb}"
			export QT_QPA_PLATFORM
			exec ${EPREFIX}/usr/$(get_libdir)/${PN}/bin/FreeCAD "\${@}"
		_EOF_
	fi
	dosym -r "/usr/$(get_libdir)/${PN}/bin/FreeCADCmd" "/usr/bin/FreeCADCmd"

	if [[ -f src/Tools/freecad-thumbnailer ]]; then
		dobin src/Tools/freecad-thumbnailer
	else
		dosym -r "/usr/$(get_libdir)/${PN}/bin/freecad-thumbnailer" "/usr/bin/freecad-thumbnailer"
	fi

	for dir in share/{applications,icons,metainfo,mime,pixmaps,thumbnailers}; do
		mv "${ED}/usr/$(get_libdir)/${PN}/${dir}" "${ED}/usr/share/" || die "mv failed"
	done

	rm -r "${ED}/usr/$(get_libdir)/${PN}/include/E57Format" || die "failed to drop unneeded include directory E57Format"
	rmdir "${ED}/usr/$(get_libdir)/${PN}/include/" || die "failed to drop unneeded include directory"

	python_optimize "${ED}/usr/share/${PN}/data/Mod/Start/" "${ED}/usr/$(get_libdir)/${PN}/"{Ext,Mod}/
	# compile main package in python site-packages as well
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst

	einfo ""
	einfo "You can load a lot of additional workbenches using the integrated AddonManager."
	einfo ""
	einfo "There are a lot of additional tools, for which FreeCAD has builtin support."
	einfo "Some of them are available in Gentoo."
	einfo "Take a look at:"
	einfo "  https://wiki.freecad.org/Installing_additional_components"
	einfo ""

	optfeature_header "External programs used by FreeCAD"
	optfeature "dependency graphs" media-gfx/graphviz
	optfeature "importing and exporting 2D AutoCAD DWG files" media-gfx/libredwg
	optfeature "importing OpenSCAD files, Mesh booleans" media-gfx/openscad
	if use bim; then
		optfeature "working with COLLADA documents" dev-python/pycollada
	fi
	if use fem || use mesh; then
		optfeature "mesh generation" sci-libs/gmsh
		optfeature "mesh solver" sci-libs/calculix-ccx
	fi

	if use python_single_target_python3_13; then
		einfo "${PN} is reported to suffer from memory leaks."
		einfo "This can cause to program abortions with python-3.13"
		einfo "Fall back to python-3.12 if that happens."
		einfo "See https://github.com/FreeCAD/FreeCAD/issues/19066 for details."
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}
