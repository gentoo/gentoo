# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
WX_GTK_VER=3.0

inherit cmake-utils eutils python-single-r1 wxwidgets multilib flag-o-matic

DESCRIPTION="Math Graphics Library"
HOMEPAGE="http://mathgl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz mirror://sourceforge/${PN}/STIX_font.tgz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fltk gif glut gsl hdf hdf5 jpeg lua mpi octave opengl openmp pdf
	png python qt4 qt5 static-libs threads wxwidgets zlib"

LANGS="ru"
for l in ${LANGS}; do
	IUSE+=" linguas_${l}"
done

RDEPEND="
	!sci-visualization/udav
	virtual/opengl
	fltk? ( x11-libs/fltk:1 )
	gif? ( media-libs/giflib )
	glut? ( media-libs/freeglut )
	gsl? ( >=sci-libs/gsl-2 )
	hdf? ( sci-libs/hdf )
	hdf5? ( >=sci-libs/hdf5-1.8[mpi=] )
	jpeg? ( virtual/jpeg:0 )
	lua? ( >=dev-lang/lua-5.1:0 )
	octave? ( >=sci-mathematics/octave-3.4.0 )
	openmp? ( sys-cluster/openmpi )
	pdf? ( media-libs/libharu )
	png? ( media-libs/libpng:0 )
	python? ( dev-python/numpy[${PYTHON_USEDEP}] ${PYTHON_DEPS} )
	qt4? ( dev-qt/qtgui:4 )
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	doc? ( app-text/texi2html virtual/texi2dvi )
	octave? ( dev-lang/swig )
	python? ( dev-lang/swig )"

REQUIRED_USE="
	mpi? ( hdf5 )
	openmp? ( !threads )
	png? ( zlib )
	pdf? ( png )
	python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/${P}-gsl-2.patch
)

pkg_setup() {
	use mpi && export CC=mpicc CXX=mpicxx
	use python && python-single-r1_pkg_setup
}

src_unpack() {
	default
	if ! [[ -d "${S}"/fonts ]]; then
		mkdir "${S}"/fonts || die
	fi
	cd "${S}"/fonts || die
	unpack STIX_font.tgz
}

src_prepare() {
	default
	epatch "${PATCHES[@]}"
	# fix for location of hdf headers
	sed -i -e 's:hdf/::g' src/data_io.cpp || die
	# bored of reporting bad libdir upstream
	sed -i \
		-e '/DESTINATION/s:lib$:lib${LIB_SUFFIX}:g' \
		{src,widgets}/CMakeLists.txt || die
	echo "" > lang/install.m || die
	# fix desktop file
	sed -i -e 's/.png//' udav/udav.desktop || die
	# prevent sandbox violation
	sed -i -e 's/update-mime-database/true/' udav/CMakeLists.txt || die
	sed -i -e 's/update-desktop-database/true/' udav/CMakeLists.txt || die
	# fix missing include, bug 564204
	sed \
		-e '/#include <QStringList>/i #include <QObject>' \
		-i json/Backend.hpp || die

	use python && \
		append-cppflags \
		-I"$(${EPYTHON} -c 'import numpy; print(numpy.get_include())')"
	use wxwidgets && need-wxwidgets unicode
}

src_configure() {
	local mycmakeargs=(
		# No clue about this option:
		# option(enable-mgl2 "Use names 'libmgl2-*' instead of 'libmgl-*'")
		-DHDF4_INCLUDE_DIR="${EPREFIX}/usr/include"
		-DMGL_LIB_INSTALL_DIR="$(get_libdir)"
		$(cmake-utils_use doc enable-all-docs)
		$(cmake-utils_use fltk enable-fltk)
		$(cmake-utils_use gif enable-gif)
		$(cmake-utils_use glut enable-glut)
		$(cmake-utils_use gsl enable-gsl)
		$(cmake-utils_use hdf enable-hdf4)
		$(cmake-utils_use hdf5 enable-hdf5_18)
		$(cmake-utils_use jpeg enable-jpeg)
		$(cmake-utils_use lua enable-lua)
		$(cmake-utils_use mpi enable-mpi)
		$(cmake-utils_use octave enable-octave)
		$(cmake-utils_use opengl enable-opengl)
		$(cmake-utils_use openmp enable-openmp)
		$(cmake-utils_use pdf enable-pdf)
		$(cmake-utils_use png enable-png)
		$(cmake-utils_use qt4 enable-qt4)
		$(cmake-utils_use qt5 enable-qt5)
		$(cmake-utils_use threads enable-pthread)
		$(cmake-utils_use python enable-python)
		$(cmake-utils_use wxwidgets enable-wx)
		$(cmake-utils_use zlib enable-zlib)
	)
	cmake-utils_src_configure
	# to whoever cares: TODO: do for multiple python ABI
	if use python; then
		sed -i \
			-e "s:--prefix=\(.*\) :--prefix=\$ENV{DESTDIR}\1 :" \
			"${CMAKE_BUILD_DIR}"/lang/cmake_install.cmake || die
	fi
}

src_install() {
	cmake-utils_src_install
	dodoc README* *.txt AUTHORS
	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/*.a || die
	fi
	if use qt4 ; then
		local lang
		insinto /usr/share/udav
		for lang in ${LANGS} ; do
			use linguas_${lang} && doins udav/udav_${lang}.qm
		done
	fi
	if use octave ; then
		insinto /usr/share/${PN}/octave
		doins "${CMAKE_BUILD_DIR}"/lang/${PN}.tar.gz
	fi
	use python && python_optimize
}

pkg_postinst() {
	if use octave; then
		octave <<-EOF
		pkg install ${EROOT}/usr/share/${PN}/octave/${PN}.tar.gz
		EOF
	fi
}

pkg_prerm() {
	if use octave; then
		octave <<-EOF
		pkg uninstall ${PN}
		EOF
	fi
}
