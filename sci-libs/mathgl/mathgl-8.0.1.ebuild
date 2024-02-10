# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.2-gtk3"

inherit cmake wxwidgets multilib flag-o-matic xdg

DESCRIPTION="Math Graphics Library"
HOMEPAGE="https://mathgl.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0/7.5.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc fltk gif glut gsl hdf hdf5 jpeg mpi octave opengl openmp pdf
	png qt5 static-libs threads wxwidgets zlib"

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
	gsl? ( >=sci-libs/gsl-2:= )
	hdf? ( sci-libs/hdf )
	hdf5? ( >=sci-libs/hdf5-1.8[mpi=] )
	jpeg? ( virtual/jpeg:0 )
	octave? ( >=sci-mathematics/octave-3.4.0 )
	openmp? ( sys-cluster/openmpi )
	pdf? ( media-libs/libharu )
	png? ( media-libs/libpng:0 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
	)
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-text/texi2html virtual/texi2dvi )
	octave? ( dev-lang/swig )"

REQUIRED_USE="
	mpi? ( hdf5 )
	openmp? ( !threads )
	png? ( zlib )
	pdf? ( png )"

pkg_setup() {
	use mpi && export CC=mpicc CXX=mpicxx
}

PATCHES=(
	# From Fedora
	"${FILESDIR}"/${PN}-libharu2.4.patch
)

src_prepare() {
	# Prevent sandbox violation
	sed -i -e 's/update-mime-database/true/' udav/CMakeLists.txt || die
	sed -i -e 's/update-desktop-database/true/' udav/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	use wxwidgets && setup-wxwidgets unicode

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
		-Denable-python=OFF
		-Denable-wx=$(usex wxwidgets)
		-Denable-zlib=$(usex zlib)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
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
}

pkg_postinst() {
	if use octave; then
		octave <<-EOF
		pkg install ${EROOT}/usr/share/${PN}/octave/${PN}.tar.gz
		EOF
	fi
	xdg_pkg_postinst
}

pkg_prerm() {
	if use octave; then
		octave <<-EOF
		pkg uninstall ${PN}
		EOF
	fi
}
