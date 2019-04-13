# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit cmake-utils desktop eapi7-ver gnome2-utils python-single-r1 toolchain-funcs

MAIN_PV=$(ver_cut 0-1)
MAJOR_PV=$(ver_cut 1-2)
MY_P="ParaView-v${PV}"

DESCRIPTION="Powerful scientific data visualization application"
HOMEPAGE="https://www.paraview.org"
SRC_URI="https://www.paraview.org/files/v${MAJOR_PV}/${MY_P}.tar.gz"

LICENSE="paraview GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="boost cg coprocessing development doc examples ffmpeg mpi mysql nvcontrol openmp plugins python +qt5 sqlite tcl test tk"

RESTRICT="mirror test"

REQUIRED_USE="python? ( mpi ${PYTHON_REQUIRED_USE} )
	mysql? ( sqlite )" # "vtksqlite, needed by vtkIOSQL" and "vtkIOSQL, needed by vtkIOMySQL"

RDEPEND="
	app-arch/lz4
	dev-libs/expat
	dev-libs/jsoncpp
	dev-libs/libxml2:2
	dev-libs/protobuf
	dev-libs/pugixml
	media-libs/freetype
	media-libs/glew:0
	media-libs/libpng:0
	media-libs/libtheora
	media-libs/tiff:0=
	sci-libs/cgnslib
	sci-libs/hdf5[mpi=]
	>=sci-libs/netcdf-4.2[hdf5]
	>=sci-libs/netcdf-cxx-4.2:3
	sci-libs/xdmf2
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	coprocessing? (
		plugins? (
			dev-python/PyQt5
			dev-qt/qtgui:5[-gles2]
		)
	)
	ffmpeg? ( virtual/ffmpeg )
	mpi? ( virtual/mpi[cxx,romio] )
	mysql? ( dev-db/mysql-connector-c )
	python? (
		${PYTHON_DEPS}
		dev-python/constantly[${PYTHON_USEDEP}]
		dev-python/incremental[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/sip[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		|| ( dev-python/twisted[${PYTHON_USEDEP}]
			dev-python/twisted-core[${PYTHON_USEDEP}]
		)
		dev-python/zope-interface[${PYTHON_USEDEP}]
		mpi? ( dev-python/mpi4py )
		qt5? ( dev-python/PyQt5[opengl,webkit,${PYTHON_USEDEP}] )
	)
	qt5? (
		dev-qt/designer:5
		dev-qt/qtgui:5[-gles2]
		dev-qt/qthelp:5
		dev-qt/qtopengl:5[-gles2]
		dev-qt/qtsql:5
		dev-qt/qttest:5
		dev-qt/qtwebkit:5
		dev-qt/qtx11extras:5
	)
	sqlite? ( dev-db/sqlite:3 )
	tcl? ( dev-lang/tcl:0= )
	tk? ( dev-lang/tk:0= )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	boost? ( dev-libs/boost[mpi?,${PYTHON_USEDEP}] )
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.1-xdmf-cstring.patch
	"${FILESDIR}"/${PN}-5.3.0-fix_buildsystem.patch
	"${FILESDIR}"/${PN}-5.5.0-allow_custom_build_type.patch
)

pkg_setup() {
	[[ ${MERGE_TYPE} != "binary" ]] && use openmp && tc-check-openmp
	python-single-r1_pkg_setup
	PVLIBDIR=$(get_libdir)/${PN}-${MAJOR_PV}
}

src_prepare() {

	# Bug #661812
	mkdir -p Plugins/StreamLinesRepresentation/doc || die

	cmake-utils_src_prepare

	# lib64 fixes
	sed -i \
		-e "s:/lib/python:/$(get_libdir)/python:g" \
		VTK/ThirdParty/xdmf3/vtkxdmf3/CMakeLists.txt || die
	sed -i \
		-e "s:lib/paraview-:$(get_libdir)/paraview-:g" \
		ParaViewCore/ServerManager/SMApplication/vtkInitializationHelper.cxx || die
}

src_configure() {
	if use qt5; then
		export QT_SELECT=qt5
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${PVLIBDIR}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
		-DEXPAT_INCLUDE_DIR="${EPREFIX}"/usr/include
		-DEXPAT_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libexpat.so
		-DOPENGL_gl_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGL.so
		-DOPENGL_glu_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGLU.so
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_COLOR_MAKEFILE=TRUE
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DVTK_Group_StandAlone=ON
		-DVTK_RENDERING_BACKEND=OpenGL2
		-DVTK_USE_FFMPEG_ENCODER=OFF
		-DVTK_USE_OFFSCREEN=TRUE
		# -DVTK_USE_SYSTEM_AUTOBAHN once we transitioned to Python 3...
		-DVTK_USE_SYSTEM_CGNS=ON
		-DVTK_USE_SYSTEM_PUGIXML=ON
		-DVTK_USE_SYSTEM_EXPAT=ON
		-DVTK_USE_SYSTEM_FREETYPE=ON
		-DVTK_USE_SYSTEM_GL2PS=OFF # doesn't compile, requires modified sources
		-DVTK_USE_SYSTEM_GLEW=ON
		-DVTK_USE_SYSTEM_HDF5=ON
		-DVTK_USE_SYSTEM_INCREMENTAL=ON
		-DVTK_USE_SYSTEM_JPEG=ON
		-DVTK_USE_SYSTEM_JSONCPP=ON
		-DVTK_USE_SYSTEM_LIBHARU=OFF # doesn't compile, requires modified sources
		-DVTK_USE_SYSTEM_LIBXML2=ON
		-DVTK_USE_SYSTEM_LZ4=ON
		-DVTK_USE_SYSTEM_NETCDF=ON
		-DVTK_USE_SYSTEM_OGGTHEORA=ON
		-DVTK_USE_SYSTEM_PNG=ON
		-DVTK_USE_SYSTEM_PROTOBUF=ON
		-DVTK_USE_SYSTEM_TIFF=ON
		-DVTK_USE_SYSTEM_XDMF2=OFF # does not compile with sci-libs/xdmf2-1.0_p141226
		-DVTK_USE_SYSTEM_ZLIB=ON
		# force this module due to incorrect build system deps
		# wrt bug 460528
		-DModule_vtkUtilitiesProcessXML=ON
		)

	mycmakeargs+=(
		-DPARAVIEW_INSTALL_DEVELOPMENT_FILES="$(usex development)"

		-DModule_vtkGUISupportQtOpenGL="$(usex qt5)"
		-DModule_vtkGUISupportQtSQL="$(usex qt5)"
		-DModule_vtkGUISupportQtWebkit="$(usex qt5)"
		-DModule_vtkRenderingQt="$(usex qt5)"
		-DModule_vtkViewsQt="$(usex qt5)"
		-DPARAVIEW_BUILD_QT_GUI="$(usex qt5)"
		-DVTK_Group_ParaViewQt="$(usex qt5)"
		-DVTK_Group_Qt="$(usex qt5)"
		-DModule_pqPython="$(usex qt5 "$(usex python)" "off")"
		$(usex qt5 "-DPARAVIEW_QT_VERSION=5" "")
		-DVTK_USE_NVCONTROL="$(usex nvcontrol)"

		-DModule_vtkInfovisBoost="$(usex boost)"

		-DPARAVIEW_USE_ICE_T="$(usex mpi)"
		-DPARAVIEW_USE_MPI_SSEND="$(usex mpi)"
		-DPARAVIEW_USE_MPI="$(usex mpi)"
		-DVTK_Group_MPI="$(usex mpi)"
		-DVTK_XDMF_USE_MPI="$(usex mpi)"
		-DXDMF_BUILD_MPI="$(usex mpi)"

		-DModule_AutobahnPython="$(usex python)"
		-DModule_pqPython="$(usex python)"
		-DModule_Twisted="$(usex python)"
		-DModule_vtkmpi4py="$(usex python)"
		-DModule_vtkPython="$(usex python)"
		-DModule_vtkWrappingPythonCore="$(usex python)"
		-DModule_ZopeInterface="$(usex python)"
		-DPARAVIEW_ENABLE_PYTHON="$(usex python)"
		-DXDMF_WRAP_PYTHON="$(usex python)"

		-DBUILD_DOCUMENTATION="$(usex doc)"

		-DBUILD_EXAMPLES="$(usex examples)"

		-DModule_vtkIOMySQL="$(usex mysql)"

		-DModule_vtksqlite="$(usex sqlite)"

		-DPARAVIEW_ENABLE_CATALYST="$(usex coprocessing)"

		-DPARAVIEW_ENABLE_FFMPEG="$(usex ffmpeg)"
		-DVTK_USE_FFMPEG_ENCODER="$(usex ffmpeg)"
		-DModule_vtkIOFFMPEG="$(usex ffmpeg)"

		-DVTK_Group_Tk="$(usex tk)"
		-DVTK_USE_TK="$(usex tk)"
		-DModule_vtkRenderingTk="$(usex tk)"
		-DModule_vtkTclTk="$(usex tcl)"
		-DModule_vtkWrappingTcl="$(usex tcl)"
		-DBUILD_TESTING="$(usex test)"
		)

	if use openmp; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE=OpenMP )
	fi

	# TODO: MantaView VaporPlugin VRPlugin
	mycmakeargs+=(
		-DPARAVIEW_BUILD_PLUGIN_AdiosReader="$(usex plugins)"
		-DPARAVIEW_BUILD_PLUGIN_AnalyzeNIfTIIO="$(usex plugins)"
		-DPARAVIEW_BUILD_PLUGIN_ArrowGlyph="$(usex plugins)"
		-DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting="$(usex plugins)"
		-DPARAVIEW_BUILD_PLUGIN_GMVReader="$(usex plugins)"
		-DPARAVIEW_BUILD_PLUGIN_Moments="$(usex plugins)"
		-DPARAVIEW_BUILD_PLUGIN_NonOrthogonalSource="$(usex plugins)"
		-DPARAVIEW_BUILD_PLUGIN_PacMan="$(usex plugins)"
		-DPARAVIEW_BUILD_PLUGIN_SierraPlotTools="$(usex plugins)"
		-DPARAVIEW_BUILD_PLUGIN_SLACTools="$(usex plugins)"
		-DPARAVIEW_BUILD_PLUGIN_StreamingParticles="$(usex plugins)"
		-DPARAVIEW_BUILD_PLUGIN_SurfaceLIC="$(usex plugins)"
		# these are always needed for plugins
		-DModule_vtkFiltersFlowPaths="$(usex plugins)"
		-DModule_vtkPVServerManagerApplication="$(usex plugins)"
		)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# remove wrapper binaries and put the actual executable in place
	for i in {paraview-config,pvserver,pvdataserver,pvrenderserver,pvbatch,pvpython,paraview}; do
		if [ -f "${ED}"/usr/lib/"$i" ]; then
			mv "${ED}"/usr/lib/"$i" "${ED}"/usr/bin/"$i" || die
		fi
	done

	# install libraries into correct directory respecting get_libdir:
	mv "${ED}"/usr/lib "${ED}"/usr/lib_tmp || die
	mkdir -p "${ED}"/usr/"${PVLIBDIR}" || die
	mv "${ED}"/usr/lib_tmp/* "${ED}"/usr/"${PVLIBDIR}" || die
	rmdir "${ED}"/usr/lib_tmp || die

	# set up the environment
	echo "LDPATH=${EPREFIX}/usr/${PVLIBDIR}" > "${T}"/40${PN} || die
	doenvd "${T}"/40${PN}

	newicon "${S}"/Applications/ParaView/pvIcon-32x32.png paraview.png
	make_desktop_entry paraview "Paraview" paraview

	use python && python_optimize "${D}"/usr/$(get_libdir)/${PN}-${MAJOR_PV}
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
