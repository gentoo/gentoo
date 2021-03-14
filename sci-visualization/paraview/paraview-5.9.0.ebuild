# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit cmake desktop python-single-r1 qmake-utils toolchain-funcs xdg-utils

MAIN_PV=$(ver_cut 0-1)
MAJOR_PV=$(ver_cut 1-2)
MY_P="ParaView-v${PV}"

DESCRIPTION="Powerful scientific data visualization application"
HOMEPAGE="https://www.paraview.org"
SRC_URI="https://www.paraview.org/files/v${MAJOR_PV}/${MY_P}.tar.xz"

LICENSE="paraview GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost cg coprocessing development doc examples ffmpeg mpi mysql nvcontrol openmp offscreen plugins python +qt5 +sqlite test tk +webengine"

RESTRICT="mirror test"

# "vtksqlite, needed by vtkIOSQL" and "vtkIOSQL, needed by vtkIOMySQL"
REQUIRED_USE="
	python? ( mpi ${PYTHON_REQUIRED_USE} )
	mysql? ( sqlite )
	webengine? ( qt5 )
	qt5? ( sqlite )
	?? ( offscreen qt5 )"

RDEPEND="
	app-arch/lz4
	dev-libs/expat
	dev-libs/jsoncpp:=
	dev-libs/libxml2:2
	dev-libs/protobuf:=
	dev-libs/pugixml
	media-libs/freetype
	media-libs/glew:0
	media-libs/libpng:0
	media-libs/libtheora
	media-libs/tiff:0=
	sci-libs/cgnslib
	sci-libs/hdf5:=[mpi=]
	>=sci-libs/netcdf-4.2[hdf5]
	>=sci-libs/netcdf-cxx-4.2:3
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	coprocessing? (
		dev-python/PyQt5
		dev-qt/qtgui:5[-gles2-only]
	)
	ffmpeg? ( media-video/ffmpeg )
	mpi? ( virtual/mpi[cxx,romio] )
	mysql? ( dev-db/mysql-connector-c )
	offscreen? ( >=media-libs/mesa-18.3.6[osmesa] )
	!offscreen? ( virtual/opengl )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/constantly[${PYTHON_MULTI_USEDEP}]
			dev-python/incremental[${PYTHON_MULTI_USEDEP}]
			dev-python/matplotlib[${PYTHON_MULTI_USEDEP}]
			dev-python/numpy[${PYTHON_MULTI_USEDEP}]
			dev-python/pygments[${PYTHON_MULTI_USEDEP}]
			dev-python/sip[${PYTHON_MULTI_USEDEP}]
			dev-python/six[${PYTHON_MULTI_USEDEP}]
			dev-python/twisted[${PYTHON_MULTI_USEDEP}]
			dev-python/zope-interface[${PYTHON_MULTI_USEDEP}]
			mpi? ( dev-python/mpi4py )
			qt5? ( dev-python/PyQt5[opengl,${PYTHON_MULTI_USEDEP}] )
		')
	)
	qt5? (
		dev-qt/designer:5
		dev-qt/qtgui:5[-gles2-only]
		dev-qt/qthelp:5
		dev-qt/qtopengl:5[-gles2-only]
		dev-qt/qtsql:5
		dev-qt/qtsvg:5
		dev-qt/qttest:5
		dev-qt/qtx11extras:5
		dev-qt/qtxmlpatterns:5
	)
	sqlite? ( dev-db/sqlite:3 )
	tk? ( dev-lang/tk:0= )
	webengine? ( dev-qt/qtwebengine:5[widgets] )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	boost? (
		$(python_gen_cond_dep '
			dev-libs/boost[mpi?,${PYTHON_MULTI_USEDEP}]
		')
	)
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.1-xdmf-cstring.patch
	"${FILESDIR}"/${PN}-5.5.0-allow_custom_build_type.patch
)

pkg_setup() {
	[[ ${MERGE_TYPE} != "binary" ]] && use openmp && tc-check-openmp
	use python && python-single-r1_pkg_setup
	PVLIBDIR=$(get_libdir)/${PN}-${MAJOR_PV}
}

src_prepare() {
	# Bug #661812
	mkdir -p Plugins/StreamLinesRepresentation/doc || die

	cmake_src_prepare

	# lib64 fixes
	sed -i \
		-e "s:/lib/python:/$(get_libdir)/python:g" \
		VTK/ThirdParty/xdmf3/vtkxdmf3/CMakeLists.txt || die
	sed -i \
		-e "s:lib/paraview-:$(get_libdir)/paraview-:g" \
		Remoting/Application/vtkInitializationHelper.cxx || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${PVLIBDIR}"
		-UBUILD_SHARED_LIBS
		-DPARAVIEW_BUILD_SHARED_LIBS=ON
		-DCMAKE_VERBOSE_MAKEFILE=ON

		-DVTK_DEFAULT_RENDER_WINDOW_OFFSCREEN=TRUE

		-DVTK_USE_OGGTHEORA_ENCODER=TRUE

		-DVTK_GROUP_ENABLE_Imaging=YES
		-DVTK_GROUP_ENABLE_Rendering=YES
		-DVTK_GROUP_ENABLE_StandAlone=YES
		-DVTK_GROUP_ENABLE_Views=YES

		# boost
		-DVTK_MODULE_ENABLE_VTK_IOInfovis="$(usex boost YES NO)"

		# coprocessing
		-DVTK_MODULE_ENABLE_ParaView_Catalyst="$(usex coprocessing YES NO)"

		# doc
		-DPARAVIEW_BUILD_DEVELOPER_DOCUMENTATION="$(usex doc)"

		# examples
		-DBUILD_EXAMPLES="$(usex examples)"

		# ffmpeg
		-DPARAVIEW_ENABLE_FFMPEG="$(usex ffmpeg)"
		-DVTK_USE_FFMPEG_ENCODER="$(usex ffmpeg)"

		# mpi
		-DPARAVIEW_USE_MPI="$(usex mpi)"
		-DXDMF_BUILD_MPI="$(usex mpi)"
		-DVTK_GROUP_ENABLE_MPI="$(usex mpi YES NO)"

		# mysql
		-DVTK_MODULE_ENABLE_VTK_IOMySQL="$(usex mysql YES NO)"

		# offscreen
		-DVTK_USE_X="$(usex !offscreen)"
		-DVTK_OPENGL_HAS_OSMESA="$(usex offscreen)"
		-DVTK_OPENGL_HAS_OSMESA="$(usex offscreen)"

		# plugins
		-DPARAVIEW_PLUGINS_DEFAULT="$(usex plugins)"

		# python
		-DModule_pqPython="$(usex python)"
		-DPARAVIEW_USE_PYTHON="$(usex python)"

		# qt5
		-DPARAVIEW_INSTALL_DEVELOPMENT_FILES="$(usex development)"
		-DPARAVIEW_USE_QT="$(usex qt5)"
		-DModule_pqPython="$(usex qt5 "$(usex python)" "off")"
		-DVTK_USE_NVCONTROL="$(usex nvcontrol)"
		-DVTK_GROUP_ENABLE_Qt="$(usex qt5 YES NO)"

		# sqlite
		-DVTK_MODULE_ENABLE_VTK_sqlite="$(usex sqlite YES NO)"

		# test
		-DBUILD_TESTING="$(usex test)"

		# tk
		-DVTK_USE_TK="$(usex tk)"
		-DVTK_GROUP_ENABLE_Tk="$(usex tk YES NO)"

		# webengine
		-DPARAVIEW_USE_QTWEBENGINE="$(usex webengine)"
		-DVTK_GROUP_ENABLE_Web="$(usex webengine YES NO)"
	)

	if use openmp; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE=OpenMP )
	fi

	if use qt5; then
		mycmakeargs+=(
			-DOPENGL_gl_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGL.so
			-DOPENGL_glu_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGLU.so
			-DQT_MOC_EXECUTABLE="$(qt5_get_bindir)/moc"
			-Dqt_xmlpatterns_executable="$(qt5_get_bindir)/xmlpatterns"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# remove wrapper binaries and put the actual executable in place
	for i in {paraview-config,pvserver,pvdataserver,pvrenderserver,pvbatch,pvpython,paraview}; do
		if [ -f "${ED}"/usr/lib/"$i" ]; then
			mv "${ED}"/usr/lib/"$i" "${ED}"/usr/bin/"$i" || die
		fi
	done

	# set up the environment
	echo "LDPATH=${EPREFIX}/usr/${PVLIBDIR}" > "${T}"/40${PN} || die
	doenvd "${T}"/40${PN}

	newicon "${S}"/Clients/ParaView/pvIcon-96x96.png paraview.png
	make_desktop_entry paraview "Paraview" paraview

	use python && python_optimize "${D}"/usr/$(get_libdir)/${PN}-${MAJOR_PV}
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
