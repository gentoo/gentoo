# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
CMAKE_MAKEFILE_GENERATOR=ninja
WEBAPP_OPTIONAL=yes
WEBAPP_MANUAL_SLOT=yes

inherit eutils flag-o-matic java-pkg-opt-2 python-single-r1 qmake-utils versionator toolchain-funcs cmake-utils virtualx webapp

# Short package version
SPV="$(get_version_component_range 1-2)"

DESCRIPTION="The Visualization Toolkit"
HOMEPAGE="http://www.vtk.org/"
SRC_URI="
	http://www.${PN}.org/files/release/${SPV}/VTK-${PV}.tar.gz
	doc? ( http://www.${PN}.org/files/release/${SPV}/${PN}DocHtml-${PV}.tar.gz )
	test? (
		http://www.${PN}.org/files/release/${SPV}/VTKData-${PV}.tar.gz
		http://www.${PN}.org/files/release/${SPV}/VTKLargeData-${PV}.tar.gz
		)
	"

LICENSE="BSD LGPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="
	all-modules aqua boost cg doc examples imaging ffmpeg gdal java json kaapi mpi
	mysql odbc offscreen postgres python qt4 rendering smp tbb test theora tk tcl
	video_cards_nvidia views web xdmf2 R +X"

REQUIRED_USE="
	all-modules? ( python xdmf2 )
	java? ( qt4 )
	python? ( ${PYTHON_REQUIRED_USE} )
	tcl? ( rendering )
	smp? ( ^^ ( kaapi tbb ) )
	test? ( python )
	tk? ( tcl )
	web? ( python )
	^^ ( X aqua offscreen )
	"

RDEPEND="
	dev-libs/expat
	dev-libs/libxml2:2
	>=media-libs/freetype-2.5.4
	media-libs/libpng:0
	media-libs/mesa
	media-libs/libtheora
	media-libs/tiff:0
	sci-libs/exodusii
	sci-libs/hdf5:=
	sci-libs/netcdf-cxx:3
	sys-libs/zlib
	virtual/jpeg:0
	virtual/opengl
	>=x11-libs/gl2ps-1.3.8
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	boost? ( >=dev-libs/boost-1.40.0[mpi?] )
	cg? ( media-gfx/nvidia-cg-toolkit )
	examples? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		sci-libs/vtkdata
	)
	ffmpeg? ( virtual/ffmpeg )
	gdal? ( sci-libs/gdal )
	java? ( >=virtual/jre-1.5:* )
	kaapi? ( <sci-libs/xkaapi-3 )
	mpi? (
		virtual/mpi[cxx,romio]
		python? ( dev-python/mpi4py[${PYTHON_USEDEP}] )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	offscreen? ( media-libs/mesa[osmesa] )
	postgres? ( dev-db/postgresql:= )
	python? (
		${PYTHON_DEPS}
		dev-python/sip[${PYTHON_USEDEP}]
		)
	)
	qt4? (
		dev-qt/designer:4
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		dev-qt/qtsql:4
		dev-qt/qtwebkit:4
		python? ( dev-python/PyQt4[${PYTHON_USEDEP}] )
		)
	tbb? ( dev-cpp/tbb )
	tcl? ( dev-lang/tcl:0= )
	tk? ( dev-lang/tk:0= )
	video_cards_nvidia? ( media-video/nvidia-settings )
	web? (
		${WEBAPP_DEPEND}
		python? (
			dev-python/autobahn[${PYTHON_USEDEP}]
			dev-python/twisted-core[${PYTHON_USEDEP}]
			dev-python/zope-interface[${PYTHON_USEDEP}]
			)
		)
	xdmf2? ( sci-libs/xdmf2 )
	R? ( dev-lang/R )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	java? ( >=virtual/jdk-1.5 )"

S="${WORKDIR}"/VTK-${PV}

PATCHES=(
	"${FILESDIR}"/${P}-freetype.patch
	"${FILESDIR}"/${P}-install.patch
	"${FILESDIR}"/${P}-system.patch
	"${FILESDIR}"/${P}-netcdf.patch
	"${FILESDIR}"/${P}-web.patch
	"${FILESDIR}"/${P}-glext.patch
	)

RESTRICT=test

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
	use python && python-single-r1_pkg_setup
	use web && webapp_pkg_setup

	append-cppflags -D__STDC_CONSTANT_MACROS -D_UNICODE
}

src_prepare() {
	sed \
		-e 's:libproj4:libproj:g' \
		-e 's:lib_proj.h:lib_abi.h:g' \
		-i CMake/FindLIBPROJ4.cmake || die

	local x
	# missing: VPIC alglib exodusII freerange ftgl libproj4 mrmpi sqlite utf8 verdict xmdf2 xmdf3
	for x in expat freetype gl2ps hdf5 jpeg jsoncpp libxml2 netcdf oggtheora png tiff zlib; do
		ebegin "Dropping bundled ${x}"
		rm -r ThirdParty/${x}/vtk${x} || die
		eend $?
	done
	rm -r \
		ThirdParty/AutobahnPython/autobahn \
		ThirdParty/Twisted/twisted \
		ThirdParty/ZopeInterface/zope \
		|| die

	use java && export JAVA_HOME="${EPREFIX}/etc/java-config-2/current-system-vm"

	if use mpi; then
		export CC=mpicc
		export CXX=mpicxx
		export FC=mpif90
		export F90=mpif90
		export F77=mpif77
	fi

	cmake-utils_src_prepare
}

src_configure() {
	# general configuration
	local mycmakeargs=(
		-Wno-dev
#		-DCMAKE_SKIP_RPATH=YES
		-DVTK_DIR="${S}"
		-DVTK_INSTALL_LIBRARY_DIR=$(get_libdir)
		-DVTK_DATA_ROOT:PATH="${EPREFIX}/usr/share/${PN}/data"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DVTK_CUSTOM_LIBRARY_SUFFIX=""
		-DBUILD_SHARED_LIBS=ON
		-DVTK_USE_SYSTEM_AUTOBAHN=ON
		-DVTK_USE_SYSTEM_EXPAT=ON
		-DVTK_USE_SYSTEM_FREETYPE=ON
		-DVTK_USE_SYSTEM_FreeType=ON
		-DVTK_USE_SYSTEM_GL2PS=ON
		-DVTK_USE_SYSTEM_HDF5=ON
		-DVTK_USE_SYSTEM_JPEG=ON
		-DVTK_USE_SYSTEM_LIBPROJ4=OFF
#		-DLIBPROJ4_DIR="${EPREFIX}/usr"
		-DVTK_USE_SYSTEM_LIBXML2=ON
		-DVTK_USE_SYSTEM_LibXml2=ON
		-DVTK_USE_SYSTEM_NETCDF=ON
		-DVTK_USE_SYSTEM_OGGTHEORA=ON
		-DVTK_USE_SYSTEM_PNG=ON
		-DVTK_USE_SYSTEM_TIFF=ON
		-DVTK_USE_SYSTEM_TWISTED=ON
		-DVTK_USE_SYSTEM_XDMF2=OFF
		-DVTK_USE_SYSTEM_XDMF3=OFF
		-DVTK_USE_SYSTEM_ZLIB=ON
		-DVTK_USE_SYSTEM_ZOPE=ON
		-DVTK_USE_SYSTEM_LIBRARIES=ON
		-DVTK_USE_GL2PS=ON
		-DVTK_USE_LARGE_DATA=ON
		-DVTK_USE_PARALLEL=ON
		-DVTK_INSTALL_NO_DEVELOPMENT=ON
	)

	mycmakeargs+=(
		-DVTK_EXTRA_COMPILER_WARNINGS=ON
		-DVTK_Group_StandAlone=ON
	)

	mycmakeargs+=(
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use_build examples EXAMPLES)
		$(cmake-utils_use_build test VTK_BUILD_ALL_MODULES_FOR_TESTS)
		$(cmake-utils_use all-modules VTK_BUILD_ALL_MODULES)
		$(cmake-utils_use doc DOCUMENTATION_HTML_HELP)
		$(cmake-utils_use imaging VTK_Group_Imaging)
		$(cmake-utils_use mpi VTK_Group_MPI)
		$(cmake-utils_use qt4 VTK_Group_Qt)
		$(cmake-utils_use rendering VTK_Group_Rendering)
		$(cmake-utils_use tk VTK_Group_Tk)
		$(cmake-utils_use views VTK_Group_Views)
		$(cmake-utils_use web VTK_Group_Web)
		$(cmake-utils_use web VTK_WWW_DIR="${ED}/${MY_HTDOCSDIR}")
		$(cmake-utils_use java VTK_WRAP_JAVA)
		$(cmake-utils_use python VTK_WRAP_PYTHON)
		$(cmake-utils_use python VTK_WRAP_PYTHON_SIP)
		$(cmake-utils_use tcl VTK_WRAP_TCL)
	)

	mycmakeargs+=(
		$(cmake-utils_use boost VTK_USE_BOOST)
		$(cmake-utils_use cg VTK_USE_CG_SHADERS)
		$(cmake-utils_use odbc VTK_USE_ODBC)
		$(cmake-utils_use offscreen VTK_USE_OFFSCREEN)
		$(cmake-utils_use offscreen VTK_OPENGL_HAS_OSMESA)
		$(cmake-utils_use smp vtkFiltersSMP)
		$(cmake-utils_use theora VTK_USE_OGGTHEORA_ENCODER)
		$(cmake-utils_use video_cards_nvidia VTK_USE_NVCONTROL)
		$(cmake-utils_use R Module_vtkFiltersStatisticsGnuR)
		$(cmake-utils_use X VTK_USE_X)
	)

	# IO
	mycmakeargs+=(
		$(cmake-utils_use ffmpeg VTK_USE_FFMPEG_ENCODER)
		$(cmake-utils_use gdal Module_vtkIOGDAL)
		$(cmake-utils_use json Module_vtkIOGeoJSON)
		$(cmake-utils_use xdmf2 Module_vtkIOXdmf2)
	)
	# Apple stuff, does it really work?
	mycmakeargs+=( $(cmake-utils_use aqua VTK_USE_COCOA) )

	if use examples || use test; then
		mycmakeargs+=( -DBUILD_TESTING=ON )
	fi

	if use kaapi; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="Kaapi" )
	elif use tbb; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="TBB" )
	else
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="Sequential" )
	fi

	if use java; then
#		local _ejavahome=${EPREFIX}/etc/java-config-2/current-system-vm
#
#	mycmakeargs+=(
#			-DJAVAC=${EPREFIX}/usr/bin/javac
#			-DJAVAC=$(java-config -c)
#			-DJAVA_AWT_INCLUDE_PATH=${JAVA_HOME}/include
#			-DJAVA_INCLUDE_PATH:PATH=${JAVA_HOME}/include
#			-DJAVA_INCLUDE_PATH2:PATH=${JAVA_HOME}/include/linux
#		)
#
		if [ "${ARCH}" == "amd64" ]; then
			mycmakeargs+=( -DJAVA_AWT_LIBRARY="${JAVA_HOME}/jre/lib/${ARCH}/libjawt.so;${JAVA_HOME}/jre/lib/${ARCH}/xawt/libmawt.so" )
		else
			mycmakeargs+=( -DJAVA_AWT_LIBRARY="${JAVA_HOME}/jre/lib/i386/libjawt.so;${JAVA_HOME}/jre/lib/i386/xawt/libmawt.so" )
		fi
	fi
	if use python; then
		mycmakeargs+=(
			-DVTK_INSTALL_PYTHON_MODULE_DIR="$(python_get_sitedir)"
			-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
			-DPYTHON_LIBRARY="$(python_get_library_path)"
			-DSIP_PYQT_DIR="${EPREFIX}/usr/share/sip"
			-DSIP_INCLUDE_DIR="$(python_get_includedir)"
			-DVTK_PYTHON_INCLUDE_DIR="$(python_get_includedir)"
			-DVTK_PYTHON_LIBRARY="$(python_get_library_path)"
			-DVTK_PYTHON_SETUP_ARGS:STRING="--prefix=${PREFIX} --root=${D}"
		)
	fi

	if use qt4; then
		mycmakeargs+=(
			-DVTK_USE_QVTK=ON
			-DVTK_USE_QVTK_OPENGL=ON
			-DVTK_USE_QVTK_QTOPENGL=ON
			-DQT_WRAP_CPP=ON
			-DQT_WRAP_UI=ON
			-DVTK_INSTALL_QT_DIR=/$(get_libdir)/qt4/plugins/designer
			-DDESIRED_QT_VERSION=4
			-DVTK_QT_VERSION=4
			-DQT_MOC_EXECUTABLE="$(qt4_get_bindir)/moc"
			-DQT_UIC_EXECUTABLE="$(qt4_get_bindir)/uic"
			-DQT_INCLUDE_DIR="${EPREFIX}/usr/include/qt4"
			-DQT_QMAKE_EXECUTABLE="$(qt4_get_bindir)/qmake"
		)
	fi

	if use R; then
		mycmakeargs+=(
#			-DR_LIBRARY_BLAS=$($(tc-getPKG_CONFIG) --libs blas)
#			-DR_LIBRARY_LAPACK=$($(tc-getPKG_CONFIG) --libs lapack)
			-DR_LIBRARY_BLAS=/usr/$(get_libdir)/R/lib/libR.so
			-DR_LIBRARY_LAPACK=/usr/$(get_libdir)/R/lib/libR.so
		)
	fi

	cmake-utils_src_configure
}

src_test() {
	local tcllib
	ln -sf "${BUILD_DIR}"/lib  "${BUILD_DIR}"/lib/Release || die
	for tcllib in "${BUILD_DIR}"/lib/lib*TCL*so; do
		ln -sf $(basename "${tcllib}").1 "${tcllib/.so/-${SPV}.so}" || die
	done
	export LD_LIBRARY_PATH="${BUILD_DIR}"/lib:"${JAVA_HOME}"/jre/lib/${ARCH}/:"${JAVA_HOME}"/jre/lib/${ARCH}/xawt/
	local VIRTUALX_COMMAND="cmake-utils_src_test"
#	local VIRTUALX_COMMAND="cmake-utils_src_test -R Java"
#	local VIRTUALX_COMMAND="cmake-utils_src_test -I 364,365"
	virtualmake
}

src_install() {
	use web && webapp_src_preinst
	# install docs
	HTML_DOCS=( "${S}"/README.html )

	cmake-utils_src_install

	use java && java-pkg_regjar "${ED}"/usr/$(get_libdir)/${PN}.jar

	if use tcl; then
		# install Tcl docs
		docinto vtk_tcl
		dodoc "${S}"/Wrapping/Tcl/README
	fi

	# install examples
	if use examples; then
		insinto /usr/share/${PN}
		mv -v Examples examples || die
		doins -r examples
	fi

	#install big docs
	if use doc; then
		cd "${WORKDIR}"/html || die
		rm -f *.md5 || die "Failed to remove superfluous hashes"
		einfo "Installing API docs. This may take some time."
		docinto html
		dodoc -r ./*
	fi

	# environment
	cat >> "${T}"/40${PN} <<- EOF
	VTK_DATA_ROOT=${EPREFIX}/usr/share/${PN}/data
	VTK_DIR=${EPREFIX}/usr/$(get_libdir)/${PN}-${SPV}
	VTKHOME=${EPREFIX}/usr
	EOF
	doenvd "${T}"/40${PN}

	use web && webapp_src_install
}
