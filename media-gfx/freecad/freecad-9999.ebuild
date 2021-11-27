# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9} )

inherit check-reqs cmake optfeature python-single-r1 xdg

DESCRIPTION="QT based Computer Aided Design application"
HOMEPAGE="https://www.freecadweb.org/ https://github.com/FreeCAD/FreeCAD"

MY_PN=FreeCAD
MY_PATCH="${P}-Gentoo-specific-fix-install-locations-of-Ext-and-Mod"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${MY_PN}/${MY_PN}.git"
	SRC_URI="https://raw.githubusercontent.com/waebbl/waebbl-gentoo/master/patches/${MY_PATCH}.patch.xz"
	S="${WORKDIR}/freecad-${PV}"
else
	MY_PV=$(ver_cut 1-2)
	MY_PV=$(ver_rs 1 '_' ${MY_PV})
	SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
		https://raw.githubusercontent.com/waebbl/waebbl-gentoo/master/patches/${P}-0005-Make-smesh-compile-with-vtk9.patch.xz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/FreeCAD-${PV}"
fi

# code is licensed LGPL-2
# examples are licensed CC-BY-SA (without note of specific version)
LICENSE="LGPL-2 CC-BY-SA-4.0"
SLOT="0"
IUSE="debug headless pcl test"
RESTRICT="!test? ( test )"

FREECAD_EXPERIMENTAL_MODULES="cloud plot ship"
FREECAD_STABLE_MODULES="addonmgr fem idf image inspection material
	openscad part-design path points raytracing robot show surface
	techdraw tux"

for module in ${FREECAD_STABLE_MODULES}; do
	IUSE="${IUSE} +${module}"
done
for module in ${FREECAD_EXPERIMENTAL_MODULES}; do
	IUSE="${IUSE} ${module}"
done
unset module

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/OpenNI2[opengl(+)]
	dev-libs/libspnav[X]
	dev-libs/xerces-c[icu]
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	>=media-libs/coin-4.0.0
	media-libs/freetype
	media-libs/qhull:=
	sci-libs/flann[openmp]
	sci-libs/hdf5:=[fortran,zlib]
	>=sci-libs/med-4.0.0-r1[python,${PYTHON_SINGLE_USEDEP}]
	sci-libs/opencascade:=[vtk(+)]
	sci-libs/orocos_kdl:=
	sys-libs/zlib
	virtual/glu
	virtual/libusb:1
	virtual/opengl
	cloud? (
		dev-libs/openssl:=
		net-misc/curl
	)
	fem? ( sci-libs/vtk:=[boost(+),python,qt5,rendering,${PYTHON_SINGLE_USEDEP}] )
	openscad? ( media-gfx/openscad )
	pcl? ( sci-libs/pcl:=[opengl,openni2(+),qt5(+),vtk(+)] )
	$(python_gen_cond_dep '
		dev-libs/boost:=[python,threads(+),${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		>=dev-python/pivy-0.6.5[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/pyside2[gui,svg,${PYTHON_USEDEP}]
		dev-python/shiboken2[${PYTHON_USEDEP}]
		addonmgr? ( dev-python/GitPython[${PYTHON_USEDEP}] )
		fem? ( dev-python/ply[${PYTHON_USEDEP}] )
	')
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/eigen-3.3.1:3
"
BDEPEND="
	app-text/dos2unix
	dev-lang/swig
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
	inspection? ( points )
	path? ( robot )
	ship? ( image plot )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.19_pre20201231-0003-Gentoo-specific-don-t-check-vcs.patch
	"${FILESDIR}"/${PN}-0.19.1-0001-Gentoo-specific-Remove-ccache-usage.patch
)

DOCS=( CODE_OF_CONDUCT.md ChangeLog.txt README.md )

CHECKREQS_DISK_BUILD="2G"

pkg_setup() {
	check-reqs_pkg_setup
	python-single-r1_pkg_setup
	[[ -z ${CASROOT} ]] && die "\${CASROOT} not set, plesae run eselect opencascade"
}

src_unpack() {
	git-r3_src_unpack
	unpack ${MY_PATCH}.patch.xz
}

src_prepare() {
	# the upstream provided file doesn't find the coin doc tag file,
	# but cmake ships a working one, so we use this.
	rm "${S}/cMake/FindCoin3D.cmake" || die

	# Fix desktop file
	sed -e 's/Exec=FreeCAD/Exec=freecad/' -i src/XDGData/org.freecadweb.FreeCAD.desktop || die

	cmake_src_prepare

	# Fix line endings on a few files for patching
	for f in src/Mod/{Cloud,Inspection,Start/StartPage}/CMakeLists.txt; do
		dos2unix -q ${f}
	done

	eapply "${WORKDIR}"/${P}-Gentoo-specific-fix-install-locations-of-Ext-and-Mod.patch
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_ADDONMGR=$(usex addonmgr)
		-DBUILD_ARCH=ON
		-DBUILD_ASSEMBLY=OFF					# deprecated
		-DBUILD_CLOUD=$(usex cloud)
		-DBUILD_COMPLETE=OFF					# deprecated
		-DBUILD_DRAFT=ON
		-DBUILD_DRAWING=ON
		-DBUILD_ENABLE_CXX_STD:STRING="C++17"	# needed for current git master
		-DBUILD_FEM=$(usex fem)
		-DBUILD_FEM_NETGEN=OFF
		-DBUILD_FLAT_MESH=ON
		-DBUILD_FORCE_DIRECTORY=ON				# force building in a dedicated directory
		-DBUILD_FREETYPE=ON						# automagic dep
		-DBUILD_GUI=$(usex !headless)
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
		-DBUILD_PLOT=$(usex plot)				# conflicts with possible external workbench
		-DBUILD_POINTS=$(usex points)
		-DBUILD_QT5=ON							# OFF means to use Qt4
		-DBUILD_RAYTRACING=$(usex raytracing)
		-DBUILD_REVERSEENGINEERING=OFF			# currently only an empty sandbox
		-DBUILD_ROBOT=$(usex robot)
		-DBUILD_SHIP=$(usex ship)				# conflicts with possible external workbench
		-DBUILD_SHOW=$(usex show)
		-DBUILD_SKETCHER=ON						# needed by draft workspace
		-DBUILD_SMESH=ON
		-DBUILD_SPREADSHEET=ON
		-DBUILD_START=ON
		-DBUILD_SURFACE=$(usex surface)
		-DBUILD_TECHDRAW=$(usex techdraw)
		-DBUILD_TEST=ON							# always build test workbench for run-time testing
		-DBUILD_TUX=$(usex tux)
		-DBUILD_VR=OFF
		-DBUILD_WEB=ON							# needed by start workspace
		-DBUILD_WITH_CONDA=OFF

		-DCMAKE_INSTALL_DATADIR=share/${PN}/data
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}
		-DCMAKE_INSTALL_INCLUDEDIR=include/${PN}
		-DCMAKE_INSTALL_LIBDIR=$(get_libdir)/${PN}

		-DFREECAD_BUILD_DEBIAN=OFF

		-DFREECAD_USE_EXTERNAL_KDL=ON
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

		-DOCCT_CMAKE_FALLBACK=ON				# don't use occt-config which isn't included in opencascade for Gentoo
	)

	# bug https://bugs.gentoo.org/788274
	local OCC_P=$(best_version sci-libs/opencascade[vtk])
	OCC_P=${OCC_P#sci-libs/}
	OCC_P=${OCC_P%-r*}
	mycmakeargs+=(
		-DOCC_INCLUDE_DIR="${CASROOT}"/include/${OCC_P}
		-DOCC_LIBRARY_DIR="${CASROOT}"/$(get_libdir)/${OCC_P}
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

	cmake_src_configure
}

# We use the FreeCADCmd binary instead of the FreeCAD binary here
# for two reasons:
# 1. It works out of the box with USE=headless as well, not needing a guard
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

	python_optimize "${ED}"/usr/share/${PN}/data/Mod/Start/StartPage "${ED}"/usr/$(get_libdir)/${PN}{/Ext,/Mod}/
	# compile main package in python site-packages as well
	python_optimize

	doenvd "${FILESDIR}/99${PN}"
}

pkg_postinst() {
	xdg_pkg_postinst

	if use plot; then
		einfo "Note: You are enabling the 'plot' USE flag."
		einfo "This conflicts with the plot workbench that can be loaded"
		einfo "via the addon manager! You can only install one of those."
	fi

	if use ship; then
		einfo "Note: You are enabling the 'ship' USE flag."
		einfo "This conflicts with the ship workbench that can be loaded"
		einfo "via the addon manager! You can only install one of those."
	fi

	einfo "You can load a lot of additional workbenches using the integrated"
	einfo "AddonManager."

	# ToDo: check opencv, pysolar (::science), elmerfem (::science)
	#		ifc++, ifcopenshell, netgen, z88 (no pkgs), calculix-ccx (::waebbl)
	einfo "There are a lot of additional tools, for which FreeCAD has builtin"
	einfo "support. Some of them are available in Gentoo. Take a look at"
	einfo "https://wiki.freecadweb.org/Installing#External_software_supported_by_FreeCAD"
	optfeature_header "Computational utilities"
	optfeature "BLAS library" sci-libs/openblas
	optfeature "statistical computation with Python" dev-python/pandas
	optfeature "scientific computation with Python" dev-python/scipy
	optfeature "symbolic math with Python" dev-python/sympy
	optfeature_header "Imaging, Plotting and Rendering utilities"
	optfeature "dependency graphs" media-gfx/graphviz
	optfeature "PBR Rendering" media-gfx/povray
	optfeature_header "Import / Export"
	optfeature "interacting with git repositories" dev-python/GitPython
	optfeature "working with COLLADA documents" dev-python/pycollada
	optfeature "YAML importer and emitter" dev-python/pyyaml
	optfeature "importing and exporting 2D AutoCAD DWG files" media-gfx/libredwg
	optfeature "importing and exporting geospatial data formats" sci-libs/gdal
	optfeature "working with projection data" sci-libs/proj
	optfeature_header "Meshing and FEM"
	optfeature "FEM mesh generator" sci-libs/gmsh
	optfeature "triangulating meshes" sci-libs/gts
	optfeature "visualization" sci-visualization/paraview
}

pkg_postrm() {
	xdg_pkg_postrm
}
