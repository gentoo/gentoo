# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
WX_GTK_VER=3.0

inherit cmake-utils eutils python-single-r1 wxwidgets multilib flag-o-matic

DESCRIPTION="Math Graphics Library"
HOMEPAGE="http://mathgl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz mirror://sourceforge/${PN}/STIX_font.tgz"

LICENSE="LGPL-3"
SLOT="0/7.5.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fltk gif glut gsl hdf hdf5 jpeg lua mpi octave opengl openmp pdf
	png python qt5 static-libs threads wxwidgets zlib"

LANGS="ru"
for l in ${LANGS}; do
	IUSE+=" l10n_${l}"
done
unset l

RDEPEND="
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
	python? (
		$(python_gen_cond_dep '
			|| (
				dev-python/numpy-python2[${PYTHON_MULTI_USEDEP}]
				dev-python/numpy[${PYTHON_MULTI_USEDEP}]
			)
		')
		${PYTHON_DEPS}
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
	)
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
	"${FILESDIR}"/${P}-mutex.patch
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

	use python && \
		append-cppflags \
		-I"$(${EPYTHON} -c 'import numpy; print(numpy.get_include())')"
	use wxwidgets && need-wxwidgets unicode
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=()
	if use hdf; then
		mycmakeargs+=(
			-DHDF4_INCLUDE_DIR="${EPREFIX}/usr/include"
		)
	fi
	mycmakeargs+=(
		# No clue about this option:
		# option(enable-mgl2 "Use names 'libmgl2-*' instead of 'libmgl-*'")
		-DMathGL_INSTALL_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
		-Denable-all-docs=$(usex doc)
		-Denable-fltk=$(usex fltk)
		-Denable-gif=$(usex gif)
		-Denable-glut=$(usex glut)
		-Denable-gsl=$(usex gsl)
		-Denable-hdf4=$(usex hdf)
		-Denable-hdf5=$(usex hdf5)
		-Denable-jpeg=$(usex jpeg)
		-Denable-lua=$(usex lua)
		-Denable-mpi=$(usex mpi)
		-Denable-octave=$(usex octave)
		-Denable-opengl=$(usex opengl)
		-Denable-openmp=$(usex openmp)
		-Denable-pdf=$(usex pdf)
		-Denable-png=$(usex png)
		-Denable-qt4=OFF
		-Denable-qt5=$(usex qt5)
		-Denable-qt5asqt=$(usex qt5)
		-Denable-pthread=$(usex threads)
		-Denable-pthr-widget=$(usex threads)
		-Denable-python=$(usex python)
		-Denable-wx=$(usex wxwidgets)
		-Denable-zlib=$(usex zlib)
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
	if use qt5 ; then
		local lang
		insinto /usr/share/udav
		for lang in ${LANGS} ; do
			use l10n_${lang} && doins udav/udav_${lang}.qm
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
