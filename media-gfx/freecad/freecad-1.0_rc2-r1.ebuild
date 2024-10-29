# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit check-reqs cmake flag-o-matic optfeature python-single-r1 qmake-utils xdg

DESCRIPTION="QT based Computer Aided Design application"
HOMEPAGE="https://www.freecad.org/ https://github.com/FreeCAD/FreeCAD"

MY_PN=FreeCAD
MY_PV="${PV/_/}"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${MY_PN}/${MY_PN}.git"
	S="${WORKDIR}/freecad-${PV}"
else
	SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/FreeCAD-${MY_PV}"
fi

# code is licensed LGPL-2
# examples are licensed CC-BY-SA (without note of specific version)
LICENSE="LGPL-2 CC-BY-SA-4.0"
SLOT="0"
IUSE="debug designer +gui +qt6 spacenav test X"

FREECAD_EXPERIMENTAL_MODULES="cloud netgen pcl"
FREECAD_STABLE_MODULES="addonmgr fem idf image inspection material
	openscad part-design path points raytracing robot show smesh
	surface techdraw tux"

for module in ${FREECAD_STABLE_MODULES}; do
	IUSE="${IUSE} +${module}"
done
for module in ${FREECAD_EXPERIMENTAL_MODULES}; do
	IUSE="${IUSE} ${module}"
done
unset module

RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/gtest
	dev-cpp/yaml-cpp
	dev-libs/boost:=
	dev-libs/libfmt:=
	dev-libs/xerces-c[icu]
	!qt6? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtxml:5
		dev-qt/qtxmlpatterns:5
	)
	qt6? (
		dev-qt/qtbase:6[concurrent,network,xml]
	)
	media-libs/freetype
	sci-libs/hdf5:=[fortran,zlib]
	>=sci-libs/med-4.0.0-r1
	sci-libs/opencascade:=[json,vtk]
	sys-libs/zlib
	cloud? (
		dev-libs/openssl:=
		net-misc/curl
	)
	fem? (
		!qt6? ( sci-libs/vtk:=[qt5,rendering] )
		qt6? ( sci-libs/vtk:=[-qt5,qt6,rendering] )
	)
	gui? (
		>=media-libs/coin-4.0.0
		virtual/glu
		virtual/opengl
		!qt6? (
			dev-qt/designer:5
			dev-qt/qtgui:5
			dev-qt/qtopengl:5
			dev-qt/qtprintsupport:5
			dev-qt/qtsvg:5
			dev-qt/qtwebengine:5[widgets]
			dev-qt/qtwidgets:5
			dev-qt/qtx11extras:5
			pcl? ( sci-libs/pcl[qt5] )
			$(python_gen_cond_dep '
				dev-python/matplotlib[${PYTHON_USEDEP}]
				>=dev-python/pivy-0.6.5[${PYTHON_USEDEP}]
				dev-python/pyside2:=[gui,svg,webchannel,webengine,${PYTHON_USEDEP}]
				dev-python/shiboken2:=[${PYTHON_USEDEP}]
			' python3_{10..11} )
		)
		qt6? (
			designer? ( dev-qt/qttools:6[designer] )
			dev-qt/qttools:6[widgets]
			dev-qt/qtbase:6[gui,opengl,widgets]
			dev-qt/qtsvg:6
			dev-qt/qtwebengine:6[widgets]
			pcl? ( sci-libs/pcl[-qt5,qt6(-)] )
			$(python_gen_cond_dep '
				dev-python/matplotlib[${PYTHON_USEDEP}]
				>=dev-python/pivy-0.6.5[${PYTHON_USEDEP}]
				dev-python/pyside6:=[gui,svg,webchannel,webengine,${PYTHON_USEDEP}]
				dev-python/shiboken6:=[${PYTHON_USEDEP}]
			' )
		)
		spacenav? ( dev-libs/libspnav[X?] )
	)
	netgen? ( media-gfx/netgen[opencascade] )
	openscad? ( media-gfx/openscad )
	pcl? ( sci-libs/pcl:=[opengl,openni2,vtk] )
	smesh? (
		!qt6? ( sci-libs/vtk:=[qt5] )
		qt6? ( sci-libs/vtk:=[-qt5,qt6] )
	)
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
		fem? ( dev-python/ply[${PYTHON_USEDEP}] )
	')
"
DEPEND="${RDEPEND}
	>=dev-cpp/eigen-3.3.1:3
	dev-cpp/ms-gsl
	test? (
		$(python_gen_cond_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
		!qt6? ( dev-qt/qttest:5 )
	)
"
BDEPEND="
	app-text/dos2unix
	dev-lang/swig
	test? (
		$(python_gen_cond_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
		!qt6? ( dev-qt/qttest:5 )
		dev-cpp/gtest
	)
"

# To get required dependencies:
# 'grep REQUIRES_MODS cMake/FreeCAD_Helpers/CheckInterModuleDependencies.cmake'
# We set the following requirements by default:
# arch, draft, drawing, import, mesh, part, qt5, sketcher, spreadsheet, start, web.
#
# Additionally, we auto-enable mesh_part, flat_mesh and smesh
# Fem actually needs smesh, but as long as we don't have a smesh package, we enable
# smesh through the mesh USE flag. Note however, the fem<-smesh dependency isn't
# reflected by the REQUIRES_MODS macro, but at
# cMake/FreeCAD_Helpers/InitializeFreeCADBuildOptions.cmake:187.
#
# The increase in auto-enabled workbenches is due to their need in parts of the
# test suite when compiled with a minimal set of USE flags.
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	designer? ( gui )
	inspection? ( points )
	path? ( robot )
	python_single_target_python3_12? ( gui? ( qt6 ) )
"
# There is no py3.12 support planned for pyside2

PATCHES=(
	"${FILESDIR}"/${PN}-9999-Gentoo-specific-don-t-check-vcs.patch
	"${FILESDIR}"/${PN}-0.21.0-0001-Gentoo-specific-disable-ccache-usage.patch
	"${FILESDIR}"/${PN}-9999-tests-src-Qt-only-build-test-for-BUILD_GUI-ON.patch
)

DOCS=( CODE_OF_CONDUCT.md README.md )

CHECKREQS_DISK_BUILD="2G"

pkg_setup() {
	check-reqs_pkg_setup
	python-single-r1_pkg_setup
	[[ -z ${CASROOT} ]] && die "\${CASROOT} not set, please run eselect opencascade"
}

src_prepare() {
	# Fix desktop file
	sed -e 's/Exec=FreeCAD/Exec=freecad/' -i src/XDGData/org.freecad.FreeCAD.desktop || die

	find "${S}" -type f -exec dos2unix -q {} \; || die "failed to convert to unix line endings"

	cmake_src_prepare
}

src_configure() {
	# -Werror=odr, -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/875221
	# https://github.com/FreeCAD/FreeCAD/issues/13173
	filter-lto

	# Fix building tests
	append-ldflags -Wl,--copy-dt-needed-entries

	local mycmakeargs=(
		-DBUILD_ADDONMGR=$(usex addonmgr)
		-DBUILD_ARCH=ON
		-DBUILD_ASSEMBLY=OFF                    # Requires OndselSolver
		-DBUILD_CLOUD=$(usex cloud)
		-DBUILD_COMPLETE=OFF					# deprecated
		-DBUILD_DRAFT=ON
		-DBUILD_DESIGNER_PLUGIN=$(usex designer)
		-DBUILD_ENABLE_CXX_STD:STRING="C++17"	# needed for current git master
		-DBUILD_FEM=$(usex fem)
		-DBUILD_FEM_NETGEN=$(usex netgen)
		-DBUILD_FLAT_MESH=ON
		-DBUILD_FORCE_DIRECTORY=ON				# force building in a dedicated directory
		-DBUILD_FREETYPE=ON						# automagic dep
		-DBUILD_GUI=$(usex gui)
		-DBUILD_IDF=$(usex idf)
		-DBUILD_IMAGE=$(usex image)
		-DBUILD_IMPORT=ON						# import module for various file formats
		-DBUILD_INSPECTION=$(usex inspection)
		-DBUILD_JTREADER=OFF					# code has been removed upstream, but option is still there
		-DBUILD_MATERIAL=$(usex material)
		-DBUILD_MESH=ON
		-DBUILD_MESH_PART=ON
		-DBUILD_OPENSCAD=$(usex openscad)
		-DBUILD_PART=ON
		-DBUILD_PART_DESIGN=$(usex part-design)
		-DBUILD_PATH=$(usex path)
		-DBUILD_POINTS=$(usex points)
		-DBUILD_RAYTRACING=$(usex raytracing)
		-DBUILD_REVERSEENGINEERING=OFF			# currently only an empty sandbox
		-DBUILD_ROBOT=$(usex robot)
		-DBUILD_SHOW=$(usex show)
		-DBUILD_SKETCHER=ON						# needed by draft workspace
		-DBUILD_SMESH=$(usex smesh)
		-DBUILD_SPREADSHEET=ON
		-DBUILD_START=ON
		-DBUILD_SURFACE=$(usex surface)
		-DBUILD_TECHDRAW=$(usex techdraw)
		-DBUILD_TEST=ON							# always build test workbench for run-time testing
		-DBUILD_TUX=$(usex tux)
		-DBUILD_VR=OFF
		-DBUILD_WEB=ON							# needed by start workspace
		-DBUILD_WITH_CONDA=OFF

		-DCMAKE_INSTALL_DATADIR=/usr/share/${PN}/data
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DCMAKE_INSTALL_INCLUDEDIR=/usr/include/${PN}
		-DCMAKE_INSTALL_PREFIX=/usr/$(get_libdir)/${PN}

		-DFREECAD_BUILD_DEBIAN=OFF

		-DFREECAD_USE_EXTERNAL_SMESH=OFF		# no package in Gentoo
		-DFREECAD_USE_EXTERNAL_ZIPIOS=OFF		# doesn't work yet, also no package in Gentoo tree
		-DFREECAD_USE_FREETYPE=ON
		-DFREECAD_USE_OCC_VARIANT:STRING="Official Version"
		-DFREECAD_USE_PCL=$(usex pcl)
		-DFREECAD_USE_PYBIND11=ON
		-DFREECAD_USE_QT_FILEDIALOG=ON
		-DFREECAD_USE_QTWEBMODULE:STRING="Qt WebEngine"

		# install python modules to site-packages' dir. True only for the main package,
		# sub-packages will still be installed inside /usr/lib64/freecad
		-DINSTALL_TO_SITEPACKAGES=ON

		# Use the version of shiboken2 that matches the selected python version
		-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
		-DPython3_EXECUTABLE=${PYTHON}
	)

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

	if use qt6; then
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
	else
		mycmakeargs+=(
			-DFREECAD_QT_MAJOR_VERSION=5
			-DFREECAD_QT_VERSION=5
			-DQT_DEFAULT_MAJOR_VERSION=5
			-DQt5Core_MOC_EXECUTABLE="$(qt5_get_bindir)/moc"
			-DQt5Core_RCC_EXECUTABLE="$(qt5_get_bindir)/rcc"
			-DBUILD_QT5=ON
			# Drawing module unmaintained and not ported to qt6
			-DBUILD_DRAWING=ON
		)
	fi

	cmake_src_configure
}

# We use the FreeCADCmd binary instead of the FreeCAD binary here
# for two reasons:
# 1. It works out of the box with USE=-gui as well, not needing a guard
# 2. We don't need virtualx.eclass and it's dependencies
# The exported environment variables are needed, so freecad does know
# where to save it's temporary files, and where to look and write it's
# configuration. Without those, there are sandbox violation, when it
# tries to create /var/lib/portage/home/.FreeCAD directory.
src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
	export FREECAD_USER_HOME="${HOME}"
	export FREECAD_USER_DATA="${T}"
	export FREECAD_USER_TEMP="${T}"
	nonfatal ./bin/FreeCADCmd --run-test 0
	popd > /dev/null || die
}

src_install() {
	cmake_src_install

	dobin src/Tools/freecad-thumbnailer

	if use gui; then
		newbin - freecad <<- _EOF_
		#!/bin/sh
		# https://github.com/coin3d/coin/issues/451
		: \${QT_QPA_PLATFORM:=xcb}
		export QT_QPA_PLATFORM
		exec /usr/$(get_libdir)/${PN}/bin/FreeCAD "\${@}"
		_EOF_
		mv "${ED}"/usr/$(get_libdir)/${PN}/share/* "${ED}"/usr/share || die "failed to move shared resources"
	fi
	dosym -r /usr/$(get_libdir)/${PN}/bin/FreeCADCmd /usr/bin/freecadcmd

	rm -r "${ED}"/usr/$(get_libdir)/${PN}/include/E57Format || die "failed to drop unneeded include directory E57Format"

	python_optimize "${ED}"/usr/share/${PN}/data/Mod/Start/StartPage "${ED}"/usr/$(get_libdir)/${PN}{/Ext,/Mod}/
	# compile main package in python site-packages as well
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst

	einfo "You can load a lot of additional workbenches using the integrated"
	einfo "AddonManager."

	# ToDo: check opencv, pysolar (::science), elmerfem (::science)
	#		ifc++, ifcopenshell, z88 (no pkgs), calculix-ccx (::waebbl)
	einfo "There are a lot of additional tools, for which FreeCAD has builtin"
	einfo "support. Some of them are available in Gentoo. Take a look at"
	einfo "https://wiki.freecadweb.org/Installing#External_software_supported_by_FreeCAD"
	optfeature_header "Computational utilities"
	optfeature "Statistical computation with Python" dev-python/pandas
	optfeature "Use scientific computation with Python" dev-python/scipy
	optfeature "Use symbolic math with Python" dev-python/sympy
	optfeature_header "Imaging, Plotting and Rendering utilities"
	optfeature "Dependency graphs" media-gfx/graphviz
	optfeature_header "Import / Export"
	optfeature "Work with COLLADA documents" dev-python/pycollada
	optfeature "YAML importer and emitter" dev-python/pyyaml
	optfeature "Importing and exporting 2D AutoCAD DWG files" media-gfx/libredwg
	optfeature "Importing and exporting geospatial data formats" sci-libs/gdal
	optfeature "Working with projection data" sci-libs/proj
	optfeature_header "Meshing and FEM"
	optfeature "FEM mesh generator" sci-libs/gmsh
	optfeature "Visualization" sci-visualization/paraview
}

pkg_postrm() {
	xdg_pkg_postrm
}
