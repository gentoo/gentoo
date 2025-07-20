# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )

inherit check-reqs cmake cuda edo flag-o-matic optfeature python-single-r1 qmake-utils toolchain-funcs xdg virtualx

DESCRIPTION="Qt based Computer Aided Design application"
HOMEPAGE="https://www.freecad.org/ https://github.com/FreeCAD/FreeCAD"

MY_PN=FreeCAD

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${MY_PN}/${MY_PN}.git"
	S="${WORKDIR}/freecad-${PV}"
else
	SRC_URI="
		https://github.com/${MY_PN}/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/FreeCAD/FreeCAD/commit/8934af10128f0bd2d0ffada946d1c93bc5d8869f.patch -> ${PN}-18423.patch
		https://github.com/FreeCAD/FreeCAD/commit/d91b3e051789623f0bc1eff65947c361e7a661d0.patch -> ${PN}-20710.patch
	"
	KEYWORDS="amd64"
	S="${WORKDIR}/FreeCAD-${PV}"
fi

# code is licensed LGPL-2
# examples are licensed CC-BY-SA (without note of specific version)
LICENSE="LGPL-2 CC-BY-SA-4.0"
SLOT="0"
IUSE="debug designer +gui netgen pcl +smesh spacenav test X"
# Modules are found in src/Mod/ and their options defined in:
# cMake/FreeCAD_Helpers/InitializeFreeCADBuildOptions.cmake
# To get their dependencies:
# 'grep REQUIRES_MODS cMake/FreeCAD_Helpers/CheckInterModuleDependencies.cmake'
IUSE+=" addonmgr assembly +bim cam cloud fem idf inspection +mesh openscad points reverse robot surface +techdraw"

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

RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/gtest
	dev-cpp/yaml-cpp
	dev-libs/boost:=
	dev-libs/libfmt:=
	dev-libs/xerces-c:=[icu]
	dev-qt/qtbase:6[concurrent,network,xml]
	media-libs/freetype
	sci-libs/opencascade:=[json]
	sys-libs/zlib
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		<dev-python/pybind11-3[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	assembly? ( sci-libs/ondselsolver )
	cloud? (
		dev-libs/openssl:=
		net-misc/curl
	)
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
		virtual/glu
		virtual/opengl
		spacenav? ( dev-libs/libspnav[X?] )
	)
	netgen? ( media-gfx/netgen[opencascade] )
	openscad? ( $(python_gen_cond_dep 'dev-python/ply[${PYTHON_USEDEP}]') )
	pcl? ( sci-libs/pcl:= )
	smesh? (
		sci-libs/hdf5:=[zlib]
		>=sci-libs/med-4.0.0-r1
		sci-libs/vtk:=
	)
"
DEPEND="${RDEPEND}
	>=dev-cpp/eigen-3.3.1:3
	dev-cpp/ms-gsl
	test? (
		gui? (
			$(python_gen_cond_dep '
				dev-python/pyside:6=[tools(-),${PYTHON_USEDEP}]
			' )
		)
	)
"
BDEPEND="
	dev-lang/swig
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.0-r1-Gentoo-specific-don-t-check-vcs.patch
	"${FILESDIR}"/${PN}-0.21.0-0001-Gentoo-specific-disable-ccache-usage.patch
	"${FILESDIR}"/${PN}-9999-tests-src-Qt-only-build-test-for-BUILD_GUI-ON.patch
	"${DISTDIR}/${PN}-18423.patch" # vtk-9.4
	"${DISTDIR}/${PN}-20710.patch" # DESTDIR in env
)

DOCS=( CODE_OF_CONDUCT.md README.md )

CHECKREQS_DISK_BUILD="2G"

cuda_get_host_compiler() {
	if [[ -n "${NVCC_CCBIN}" ]]; then
		echo "${NVCC_CCBIN}"
		return
	fi

	if [[ -n "${CUDAHOSTCXX}" ]]; then
		echo "${CUDAHOSTCXX}"
		return
	fi

	if ! has_version dev-util/nvidia-cuda-toolkit ; then
		return
	fi

	einfo "Trying to find working CUDA host compiler"

	if ! tc-is-gcc && ! tc-is-clang; then
		die "$(tc-get-compiler-type) compiler is not supported"
	fi

	local compiler compiler_type compiler_version
	local package package_version
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

	while ! nvcc -v -ccbin "${NVCC_CCBIN}" - -x cu <<<"int main(){}" &>> "${T}/cuda_get_host_compiler.log" ; do
		eend 1

		while true; do
			# prepare next version
			if ! package_version="<$(best_version "${package_version}")"; then
				die "could not find a supported version of ${compiler}"
			fi

			NVCC_CCBIN="${compiler}-$(ver_cut 1 "${package_version/#<${package}-/}")"

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

src_prepare() {
	# Fix desktop file
	sed -e 's/Exec=FreeCAD/Exec=freecad/' -i src/XDGData/org.freecad.FreeCAD.desktop || die

	# deprecated in python-3.11 removed in python-3.13
	sed -e '/import imghdr/d' -i src/Mod/CAM/CAMTests/TestCAMSanity.py || die

	cmake_src_prepare
}

src_configure() {
	# -Werror=odr, -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/875221
	# https://github.com/FreeCAD/FreeCAD/issues/13173
	append-flags -fno-strict-aliasing
	filter-lto

	# Fix building tests
	if ! tc-ld-is-mold; then # 940524
		append-ldflags -Wl,--copy-dt-needed-entries
	fi

	# cmake-4
	# https://github.com/FreeCAD/FreeCAD/issues/20246
	: "${CMAKE_POLICY_VERSION_MINIMUM:=3.10}"
	export CMAKE_POLICY_VERSION_MINIMUM

	local mycmakeargs=(
		-DCMAKE_POLICY_DEFAULT_CMP0144="OLD" # FLANN_ROOT
		-DCMAKE_POLICY_DEFAULT_CMP0167="OLD" # FindBoost
		-DCMAKE_POLICY_DEFAULT_CMP0175="OLD" # add_custom_command
		-DCMAKE_POLICY_DEFAULT_CMP0153="OLD" # exec_program

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
		-DBUILD_CLOUD=$(usex cloud)
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

		-DCMAKE_INSTALL_DATADIR=/usr/share/${PN}/data
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DCMAKE_INSTALL_INCLUDEDIR=/usr/include/${PN}
		-DCMAKE_INSTALL_PREFIX=/usr/$(get_libdir)/${PN}

		-DFREECAD_BUILD_DEBIAN=OFF

		-DFREECAD_USE_EXTERNAL_ONDSELSOLVER=$(usex assembly)
		-DFREECAD_USE_EXTERNAL_SMESH=OFF		# no package in Gentoo
		-DFREECAD_USE_EXTERNAL_ZIPIOS=OFF		# doesn't work yet, also no package in Gentoo tree
		-DFREECAD_USE_EXTERNAL_FMT="yes"
		-DFREECAD_USE_EXTERNAL_KDL=OFF # https://github.com/FreeCAD/FreeCAD/commit/9f98866
		-DFREECAD_USE_FREETYPE=ON
		-DFREECAD_USE_OCC_VARIANT:STRING="Official Version"
		-DFREECAD_USE_PCL=$(usex pcl)
		-DFREECAD_USE_PYBIND11=ON
		-DFREECAD_USE_QT_FILEDIALOG=ON

		# install python modules to site-packages' dir. True only for the main package,
		# sub-packages will still be installed inside /usr/lib64/freecad
		-DINSTALL_TO_SITEPACKAGES=ON

		# Use the version of pyside[tools] that matches the selected python version
		-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
		# -DPython3_EXECUTABLE=${EPYTHON}

		-DPACKAGE_WCREF="${PVR} (gentoo)"
		-DPACKAGE_WCURL="git://github.com/FreeCAD/FreeCAD.git ${PV}"
	)

	if [[ ${PV} == *9999* ]]; then
		mycmakeargs+=(
			-DENABLE_DEVELOPER_TESTS=ON
		)
	else
		mycmakeargs+=(
			-DENABLE_DEVELOPER_TESTS=OFF
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

	if use fem || use smesh; then
		export CUDAHOSTCXX="$(cuda_get_host_compiler)"
		cuda_add_sandbox
	fi

	if use gui; then
		mycmakeargs+=(
			-DFREECAD_QT_MAJOR_VERSION=6
			-DFREECAD_QT_VERSION=6
			-DQT_DEFAULT_MAJOR_VERSION=6
			-DQt6Core_MOC_EXECUTABLE="$(qt6_get_bindir)/moc"
			-DQt6Core_RCC_EXECUTABLE="$(qt6_get_bindir)/rcc"
			-DBUILD_QT5=OFF
			# Drawing module unmaintained and not ported to qt6
			-DBUILD_DRAWING=OFF
		)
	fi

	addpredict "/dev/char/"
	[[ -c "/dev/udmabuf" ]] && addwrite "/dev/udmabuf"

	cmake_src_configure
}

# We use the FreeCADCmd binary instead of the FreeCAD binary here
# for two reasons:
# 1. It works out of the box with USE=-gui as well, not needing a guard
# 2. We don't need virtualx.eclass and its dependencies
# The environment variables are needed, so that FreeCAD knows
# where to save its temporary files, and where to look and write its
# configuration. Without those, there is a sandbox violation, when it
# tries to create /var/lib/portage/home/.FreeCAD directory.
src_test() {
	cd "${BUILD_DIR}" || die

	# No module named 'ifcopenshell' #940465
	rm "${BUILD_DIR}/Mod/BIM/nativeifc/ifc_performance_test.py" || die

	local -x FREECAD_USER_HOME="${HOME}"
	local -x FREECAD_USER_DATA="${T}"
	local -x FREECAD_USER_TEMP="${T}"

	local fail=""
	local run
	nonfatal \
		edo "${BUILD_DIR}/bin/FreeCADCmd" \
			--run-test 0 \
			--set-config AppHomePath="${BUILD_DIR}/" \
			--log-file "${T}/FreeCADCmd.log" \
		|| fail+=" FreeCADCmd"

	if use gui; then
		# this is naive
		addpredict "/dev/char/"
		addwrite "/dev/dri/renderD128"
		addwrite "/dev/dri/card0"
		[[ -c "/dev/nvidiactl" ]] && addwrite "/dev/nvidiactl"
		[[ -c "/dev/nvidia-uvm" ]] && addwrite "/dev/nvidia-uvm"
		[[ -c "/dev/nvidia-uvm-tools" ]] && addwrite "/dev/nvidia-uvm-tools"
		[[ -c "/dev/nvidia0" ]] && addwrite "/dev/nvidia0"
		[[ -c "/dev/udmabuf" ]] && addwrite "/dev/udmabuf"

		nonfatal \
			virtx edo "${BUILD_DIR}/bin/FreeCAD" \
				--run-test 0 \
				--set-config AppHomePath="${BUILD_DIR}/" \
				--log-file "${T}/FreeCAD.log" \
			|| fail+=" FreeCAD"

		run=virtx
	fi

	# nonfatal \
		${run} cmake_src_test || fail+=" cmake"
	if [[ -n "${fail}" ]]; then
		eerror "${fail}"
		die "${fail}"
	fi
}

src_install() {
	cmake_src_install

	if [[ -f src/Tools/freecad-thumbnailer ]]; then
		dobin src/Tools/freecad-thumbnailer
	fi

	if [[ -f freecad-thumbnailer ]]; then
		dobin freecad-thumbnailer
	fi

	if use gui; then
		newbin - freecad <<- _EOF_
		#!/bin/sh
		# https://github.com/coin3d/coin/issues/451
		: "\${QT_QPA_PLATFORM:=xcb}"
		export QT_QPA_PLATFORM
		exec /usr/$(get_libdir)/${PN}/bin/FreeCAD "\${@}"
		_EOF_
		mv "${ED}/usr/$(get_libdir)/${PN}/share/"* "${ED}/usr/share" || die "failed to move shared resources"
	fi
	dosym -r "/usr/$(get_libdir)/${PN}/bin/FreeCADCmd" "/usr/bin/freecadcmd"

	rm -r "${ED}/usr/$(get_libdir)/${PN}/include/E57Format" || die "failed to drop unneeded include directory E57Format"

	python_optimize "${ED}/usr/share/${PN}/data/Mod/Start/StartPage" "${ED}/usr/$(get_libdir)/${PN}/"{Ext,Mod}/
	# compile main package in python site-packages as well
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst

	einfo "You can load a lot of additional workbenches using the integrated"
	einfo "AddonManager."

	einfo "There are a lot of additional tools, for which FreeCAD has builtin"
	einfo "support. Some of them are available in Gentoo. Take a look at"
	einfo "https://wiki.freecad.org/Installing_additional_components"
	optfeature_header "External programs used by FreeCAD"
	optfeature "dependency graphs" media-gfx/graphviz
	optfeature "importing and exporting 2D AutoCAD DWG files" media-gfx/libredwg
	optfeature "importing OpenSCAD files, Mesh booleans" media-gfx/openscad
	use bim && optfeature "working with COLLADA documents" dev-python/pycollada
	if use fem || use mesh; then
		optfeature "mesh generation" sci-libs/gmsh
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}
