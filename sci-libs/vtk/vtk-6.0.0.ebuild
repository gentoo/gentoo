# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
CMAKE_MAKEFILE_GENERATOR=ninja

inherit eutils flag-o-matic java-pkg-opt-2 python-single-r1 qmake-utils versionator toolchain-funcs cmake-utils virtualx

# Short package version
SPV="$(get_version_component_range 1-2)"

DESCRIPTION="The Visualization Toolkit"
HOMEPAGE="http://www.vtk.org/"
SRC_URI="
	http://www.${PN}.org/files/release/${SPV}/${P/_rc/.rc}.tar.gz
	doc? ( http://www.${PN}.org/files/release/${SPV}/${PN}DocHtml-${PV}.tar.gz )"

LICENSE="BSD LGPL-2"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="
	aqua boost cg doc examples imaging ffmpeg java mpi mysql odbc
	offscreen postgres python qt4 rendering test theora tk tcl
	video_cards_nvidia views R +X"

REQUIRED_USE="
	java? ( qt4 )
	python? ( ${PYTHON_REQUIRED_USE} )
	tcl? ( rendering )
	test? ( python )
	tk? ( tcl )
	^^ ( X aqua offscreen )"

RDEPEND="
	dev-libs/expat
	dev-libs/libxml2:2
	media-libs/freetype
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
	java? ( >=virtual/jre-1.5:* )
	mpi? ( virtual/mpi[cxx,romio] )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	offscreen? ( media-libs/mesa[osmesa] )
	postgres? ( dev-db/postgresql:= )
	python? (
		${PYTHON_DEPS}
		dev-python/sip[${PYTHON_USEDEP}]
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
	tcl? ( dev-lang/tcl:0= )
	tk? ( dev-lang/tk:0= )
	video_cards_nvidia? ( media-video/nvidia-settings )
	R? ( dev-lang/R )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	java? ( >=virtual/jdk-1.5 )
	test? ( sci-libs/vtkdata )"

S="${WORKDIR}"/VTK${PV}

PATCHES=(
	"${FILESDIR}"/${P}-cg-path.patch
	"${FILESDIR}"/${P}-install.patch
	"${FILESDIR}"/${P}-system.patch
	"${FILESDIR}"/${P}-netcdf.patch
	"${FILESDIR}"/${P}-vtkpython.patch
	)

RESTRICT=test

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
	use python && python-single-r1_pkg_setup

	append-cppflags -D__STDC_CONSTANT_MACROS -D_UNICODE
}

src_prepare() {
	sed \
		-e 's:libproj4:libproj:g' \
		-e 's:lib_proj.h:lib_abi.h:g' \
		-i CMake/FindLIBPROJ4.cmake || die

	local x
	for x in expat freetype gl2ps hdf5 jpeg libxml2 netcdf oggtheora png tiff zlib; do
		rm -r ThirdParty/${x}/vtk${x} || die
	done

	if use examples || use test; then
		# Replace relative path ../../../VTKData with
		# otherwise it will break on symlinks.
		grep -rl '\.\./\.\./\.\./\.\./VTKData' . | xargs \
			sed \
				-e "s|\.\./\.\./\.\./\.\./VTKData|${EPREFIX}/usr/share/vtk/data|g" \
				-e "s|\.\./\.\./\.\./\.\./\.\./VTKData|${EPREFIX}/usr/share/vtk/data|g" \
				-i || die
	fi

	use java && export JAVA_HOME="${EPREFIX}/etc/java-config-2/current-system-vm"

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
#		-DVTK_USE_SYSTEM_XDMF2=ON
		-DVTK_USE_SYSTEM_ZLIB=ON
		-DVTK_USE_SYSTEM_LIBRARIES=ON
		-DVTK_USE_GL2PS=ON
		-DVTK_USE_PARALLEL=ON
	)

	mycmakeargs+=(
		-DVTK_EXTRA_COMPILER_WARNINGS=ON
		-DVTK_Group_StandAlone=ON
	)

	mycmakeargs+=(
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use_build examples EXAMPLES)
		$(cmake-utils_use_build test TESTING)
		$(cmake-utils_use_build test VTK_BUILD_ALL_MODULES_FOR_TESTS)
		$(cmake-utils_use doc DOCUMENTATION_HTML_HELP)
		$(cmake-utils_use imaging VTK_Group_Imaging)
		$(cmake-utils_use mpi VTK_Group_MPI)
		$(cmake-utils_use qt4 VTK_Group_Qt)
		$(cmake-utils_use rendering VTK_Group_Rendering)
		$(cmake-utils_use tk VTK_Group_Tk)
		$(cmake-utils_use views VTK_Group_Views)
		$(cmake-utils_use java VTK_WRAP_JAVA)
		$(cmake-utils_use python VTK_WRAP_PYTHON)
		$(cmake-utils_use python VTK_WRAP_PYTHON_SIP)
		$(cmake-utils_use tcl VTK_WRAP_TCL)
#		-DVTK_BUILD_ALL_MODULES=ON
	)

	mycmakeargs+=(
		$(cmake-utils_use boost VTK_USE_BOOST)
		$(cmake-utils_use cg VTK_USE_CG_SHADERS)
		$(cmake-utils_use odbc VTK_USE_ODBC)
		$(cmake-utils_use offscreen VTK_USE_OFFSCREEN)
		$(cmake-utils_use offscreen VTK_OPENGL_HAS_OSMESA)
		$(cmake-utils_use theora VTK_USE_OGGTHEORA_ENCODER)
		$(cmake-utils_use ffmpeg VTK_USE_FFMPEG_ENCODER)
		$(cmake-utils_use video_cards_nvidia VTK_USE_NVCONTROL)
		$(cmake-utils_use R Module_vtkFiltersStatisticsGnuR)
		$(cmake-utils_use X VTK_USE_X)
	)

	# Apple stuff, does it really work?
	mycmakeargs+=( $(cmake-utils_use aqua VTK_USE_COCOA) )

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

	cat >> "${BUILD_DIR}"/Utilities/MaterialLibrary/ProcessShader.sh <<- EOF
	#!${EPREFIX}/bin/bash

	export LD_LIBRARY_PATH="${BUILD_DIR}"/lib
	"${BUILD_DIR}"/bin/vtkProcessShader \$@
	EOF
	chmod 750 "${BUILD_DIR}"/Utilities/MaterialLibrary/ProcessShader.sh || die
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
		insinto "/usr/share/doc/${PF}/api-docs"
		doins -r ./*
	fi

	# environment
	cat >> "${T}"/40${PN} <<- EOF
	VTK_DATA_ROOT=${EPREFIX}/usr/share/${PN}/data
	VTK_DIR=${EPREFIX}/usr/$(get_libdir)/${PN}-${SPV}
	VTKHOME=${EPREFIX}/usr
	EOF
	doenvd "${T}"/40${PN}
}
