# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils multilib versionator python-single-r1 cmake-utils

MAIN_PV=$(get_major_version)
MAJOR_PV=$(get_version_component_range 1-2)
MY_P="ParaView-v${PV}-source"

DESCRIPTION="ParaView is a powerful scientific data visualization application"
HOMEPAGE="http://www.paraview.org"
SRC_URI="http://www.paraview.org/files/v${MAJOR_PV}/${MY_P}.tar.gz"
RESTRICT="mirror"

LICENSE="paraview GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="boost cg coprocessing development doc examples ffmpeg mpi mysql nvcontrol plugins python qt4 sqlite tcl test tk"
RESTRICT="test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	mysql? ( sqlite )" # "vtksqlite, needed by vtkIOSQL" and "vtkIOSQL, needed by vtkIOMySQL"

RDEPEND="
	dev-libs/expat
	>=dev-libs/jsoncpp-0.10.1
	dev-libs/libxml2:2
	dev-libs/protobuf
	media-libs/freetype
	media-libs/libpng:0
	media-libs/libtheora
	media-libs/tiff:0=
	sci-libs/hdf5[mpi=]
	>=sci-libs/netcdf-4.2[hdf5]
	>=sci-libs/netcdf-cxx-4.2:3
	sys-libs/zlib
	virtual/jpeg:0
	virtual/opengl
	>=x11-libs/gl2ps-1.3.8
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	coprocessing? (
		plugins? (
			dev-python/PyQt4
			dev-qt/qtgui:4
		)
	)
	ffmpeg? ( virtual/ffmpeg )
	mpi? ( virtual/mpi[cxx,romio] )
	mysql? ( virtual/mysql )
	python? (
		${PYTHON_DEPS}
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/sip[${PYTHON_USEDEP}]
		dev-python/twisted-core
		dev-python/zope-interface[${PYTHON_USEDEP}]
		mpi? ( dev-python/mpi4py )
		qt4? ( dev-python/PyQt4[opengl,webkit,${PYTHON_USEDEP}] )
	)
	qt4? (
		dev-qt/designer:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		dev-qt/qthelp:4[compat]
		dev-qt/qtsql:4
		dev-qt/qtwebkit:4
	)
	sqlite? ( dev-db/sqlite:3 )
	tcl? ( dev-lang/tcl:0= )
	tk? ( dev-lang/tk:0= )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	boost? ( >=dev-libs/boost-1.40.0[mpi?,${PYTHON_USEDEP}] )
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python-single-r1_pkg_setup
	PVLIBDIR=$(get_libdir)/${PN}-${MAJOR_PV}
}

src_prepare() {
	# see patch headers for description
	epatch "${FILESDIR}"/${PN}-4.0.1-xdmf-cstring.patch \
		"${FILESDIR}"/${PN}-4.0.1-gcc-4.7.patch \
		"${FILESDIR}"/${PN}-4.1.0-no-fatal-warnings.patch \
		"${FILESDIR}"/${PN}-4.2.0-protobuf.patch \
		"${FILESDIR}"/${PN}-4.2.0-removesqlite.patch \
		"${FILESDIR}"/${PN}-4.2.0-vtk-freetype.patch \
		"${FILESDIR}"/${P}-protobuf-2.6.patch \
		"${FILESDIR}"/${P}-fix-development-install.patch

	# lib64 fixes
	sed -i \
		-e "s:/usr/lib:${EPREFIX}/usr/$(get_libdir):g" \
		 VTK/ThirdParty/xdmf2/vtkxdmf2/libsrc/CMakeLists.txt || die
	sed -i \
		-e "s:\/lib\/python:\/$(get_libdir)\/python:g" \
		 VTK/ThirdParty/xdmf2/vtkxdmf2/CMake/setup_install_paths.py || die
	sed -i \
		-e "s:lib/paraview-:$(get_libdir)/paraview-:g" \
		CMakeLists.txt \
		Plugins/SciberQuestToolKit/CMakeLists.txt \
		ParaViewConfig.cmake.in \
		CoProcessing/PythonCatalyst/vtkCPPythonScriptPipeline.cxx \
		ParaViewCore/ClientServerCore/Core/vtkProcessModuleInitializePython.h \
		ParaViewCore/ClientServerCore/Core/vtkPVPluginTracker.cxx \
		Plugins/SciberQuestToolKit/ParaViewPlugin/CMakeLists.txt \
		Plugins/SciberQuestToolKit/SciberQuest/CMakeLists.txt || die

	# no proper switch
	use nvcontrol || {
		sed -i \
			-e '/VTK_USE_NVCONTROL/s#1#0#' \
			VTK/Rendering/OpenGL/CMakeLists.txt || die
	}
}

src_configure() {
	# VTK_USE_SYSTEM_QTTESTING
	# PARAVIEW_USE_SYSTEM_AUTOBAHN
	local mycmakeargs=(
		-DPV_INSTALL_LIB_DIR="${PVLIBDIR}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
		-DEXPAT_INCLUDE_DIR="${EPREFIX}"/usr/include
		-DEXPAT_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libexpat.so
		-DOPENGL_gl_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGL.so
		-DOPENGL_glu_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGLU.so
		-DBUILD_SHARED_LIBS=ON
		-DVTK_USE_SYSTEM_EXPAT=ON
		-DVTK_USE_SYSTEM_FREETYPE=ON
		-DVTK_USE_SYSTEM_GL2PS=ON
		-DVTK_USE_SYSTEM_HDF5=ON
		-DVTK_USE_SYSTEM_JPEG=ON
		-DVTK_USE_SYSTEM_JSONCPP=ON
		-DVTK_USE_SYSTEM_LIBXML2=ON
		-DVTK_USE_SYSTEM_NETCDF=ON
		-DVTK_USE_SYSTEM_OGGTHEORA=ON
		-DVTK_USE_SYSTEM_PNG=ON
		-DVTK_USE_SYSTEM_PROTOBUF=ON
		-DVTK_USE_SYSTEM_TIFF=ON
		-DVTK_USE_SYSTEM_XDMF2=OFF
		-DVTK_USE_SYSTEM_ZLIB=ON
		-DPARAVIEW_USE_SYSTEM_MPI4PY=ON
		-DVTK_USE_SYSTEM_ZOPE=ON
		-DVTK_USE_SYSTEM_TWISTED=ON
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_COLOR_MAKEFILE=TRUE
		-DVTK_USE_OFFSCREEN=TRUE
		-DCMAKE_USE_PTHREADS=ON
		-DVTK_USE_FFMPEG_ENCODER=OFF
		-DPROTOC_LOCATION=$(type -P protoc)
		-DVTK_Group_StandAlone=ON
		# force this module due to incorrect build system deps
		# wrt bug 460528
		-DModule_vtkUtilitiesProcessXML=ON
		)

	# TODO: XDMF_USE_MYSQL?
	# VTK_WRAP_JAVA
	mycmakeargs+=(
		$(cmake-utils_use development PARAVIEW_INSTALL_DEVELOPMENT_FILES)
		$(cmake-utils_use qt4 PARAVIEW_BUILD_QT_GUI)
		$(cmake-utils_use qt4 Module_vtkGUISupportQtOpenGL)
		$(cmake-utils_use qt4 Module_vtkGUISupportQtSQL)
		$(cmake-utils_use qt4 Module_vtkGUISupportQtWebkit)
		$(cmake-utils_use qt4 Module_vtkRenderingQt)
		$(cmake-utils_use qt4 Module_vtkViewsQt)
		$(cmake-utils_use qt4 VTK_Group_ParaViewQt)
		$(cmake-utils_use qt4 VTK_Group_Qt)
		$(cmake-utils_use !qt4 PQWIDGETS_DISABLE_QTWEBKIT)
		$(cmake-utils_use boost Module_vtkInfovisBoost)
		$(cmake-utils_use boost Module_vtkInfovisBoostGraphAlg)
		$(cmake-utils_use mpi PARAVIEW_USE_MPI)
		$(cmake-utils_use mpi PARAVIEW_USE_MPI_SSEND)
		$(cmake-utils_use mpi PARAVIEW_USE_ICE_T)
		$(cmake-utils_use mpi VTK_Group_MPI)
		$(cmake-utils_use mpi VTK_XDMF_USE_MPI)
		$(cmake-utils_use mpi XDMF_BUILD_MPI)
		$(cmake-utils_use python PARAVIEW_ENABLE_PYTHON)
		$(cmake-utils_use python VTK_Group_ParaViewPython)
		$(cmake-utils_use python XDMF_WRAP_PYTHON)
		$(cmake-utils_use python Module_vtkPython)
		$(cmake-utils_use python Module_pqPython)
		$(cmake-utils_use python Module_vtkWrappingPythonCore)
		$(cmake-utils_use python Module_vtkPVPythonSupport)
		$(cmake-utils_use python Module_AutobahnPython)
		$(cmake-utils_use python Module_Twisted)
		$(cmake-utils_use python Module_ZopeInterface)
		$(cmake-utils_use python Module_vtkmpi4py)
		$(usex qt4 "$(cmake-utils_use python Module_pqPython)" "-DModule_pqPython=OFF")
		$(cmake-utils_use doc BUILD_DOCUMENTATION)
		$(cmake-utils_use doc PARAVIEW_BUILD_WEB_DOCUMENTATION)
		$(cmake-utils_use examples BUILD_EXAMPLES)
		$(cmake-utils_use cg VTK_USE_CG_SHADERS)
		$(cmake-utils_use mysql Module_vtkIOMySQL)
		$(cmake-utils_use sqlite Module_vtksqlite)
		$(cmake-utils_use coprocessing PARAVIEW_ENABLE_CATALYST)
		$(cmake-utils_use ffmpeg PARAVIEW_ENABLE_FFMPEG)
		$(cmake-utils_use ffmpeg VTK_USE_FFMPEG_ENCODER)
		$(cmake-utils_use ffmpeg Module_vtkIOFFMPEG)
		$(cmake-utils_use tk VTK_Group_Tk)
		$(cmake-utils_use tk VTK_USE_TK)
		$(cmake-utils_use tk Module_vtkRenderingTk)
		$(cmake-utils_use tcl Module_vtkTclTk)
		$(cmake-utils_use tcl Module_vtkWrappingTcl)
		$(cmake-utils_use test BUILD_TESTING)
		)

	if use qt4 ; then
		mycmakeargs+=( -DVTK_INSTALL_QT_DIR=/${PVLIBDIR}/plugins/designer )
		if use python ; then
			# paraview cannot guess sip directory properly
			mycmakeargs+=( -DSIP_INCLUDE_DIR="${EPREFIX}$(python_get_includedir)" )
		fi
	fi

	# TODO: MantaView VaporPlugin VRPlugin
	mycmakeargs+=(
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_AdiosReader)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_AnalyzeNIfTIIO)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_ArrowGlyph)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_EyeDomeLighting)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_ForceTime)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_GMVReader)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_H5PartReader)
		$(cmake-utils_use plugins RAVIEW_BUILD_PLUGIN_MobileRemoteControl)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_Moments)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_NonOrthogonalSource)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_PacMan)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_PointSprite)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_PrismPlugin)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_QuadView)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_SLACTools)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_SciberQuestToolKit)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_SierraPlotTools)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_StreamingParticles)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_SurfaceLIC)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_UncertaintyRendering)
		# these are always needed for plugins
		$(cmake-utils_use plugins Module_vtkFiltersFlowPaths)
		$(cmake-utils_use plugins Module_vtkPVServerManagerApplication)
		)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	# set up the environment
	echo "LDPATH=${EPREFIX}/usr/${PVLIBDIR}" > "${T}"/40${PN}

	newicon "${S}"/Applications/ParaView/pvIcon-32x32.png paraview.png
	make_desktop_entry paraview "Paraview" paraview

	use python && python_optimize "${D}"/usr/$(get_libdir)/${PN}-${MAJOR_PV}
}

pkg_postinst() {
	# with Qt4.5 there seem to be issues reading data files
	# under certain locales. Setting LC_ALL=C should fix these.
	elog ""
	elog "If you experience data corruption during parsing of"
	elog "data files with paraview please try setting your"
	elog "locale to LC_ALL=C."
	elog "If you plan to use paraview component from an existing shell"
	elog "you should run env-update and . /etc/profile first"
	elog ""
	elog "paraview no longer exports bundled python modules in PYTHONPATH"
	elog "globally due to clashes of bundled packages with system-wide"
	elog "site-packages. If you want to use paraview's python modules"
	elog "export"
	elog "  PYTHONPATH=${EPREFIX}/usr/${PVLIBDIR}:${EPREFIX}/usr/${PVLIBDIR}/site-packages"
	elog "as needed."
}
