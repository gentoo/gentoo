# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit cmake wxwidgets xdg

DESCRIPTION="Math Graphics Library"
HOMEPAGE="https://mathgl.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0/7.5.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fltk gif glut gsl hdf hdf5 jpeg mpi octave opengl openmp pdf
	png qt6 threads wxwidgets zlib"

LANGS="ru"
for l in ${LANGS}; do
	IUSE+=" l10n_${l}"
done
unset l

REQUIRED_USE="
	mpi? ( hdf5 )
	openmp? ( !threads )
	png? ( zlib )
	pdf? ( png )"

RDEPEND="
	virtual/opengl
	fltk? ( x11-libs/fltk:1= )
	gif? ( media-libs/giflib:= )
	glut? ( media-libs/freeglut )
	gsl? ( >=sci-libs/gsl-2:= )
	hdf? ( sci-libs/hdf )
	hdf5? ( >=sci-libs/hdf5-1.8:=[mpi=] )
	jpeg? ( media-libs/libjpeg-turbo:= )
	octave? ( >=sci-mathematics/octave-3.4.0:= )
	openmp? ( sys-cluster/openmpi )
	pdf? ( media-libs/libharu:= )
	png? ( media-libs/libpng:= )
	qt6? (
		dev-qt/qt5compat:6
		dev-qt/qtbase:6[gui,opengl,widgets]
	)
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}=[X] )
	zlib? ( virtual/zlib:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/texi2html
		virtual/texi2dvi
	)
	octave? ( dev-lang/swig )"

PATCHES=(
	"${FILESDIR}"/${P}-libharu2.4.patch # from Fedora, rebased for 8.0.3
	"${FILESDIR}"/${P}-sandbox-violation.patch # bug 808713
)

pkg_setup() {
	use mpi && export CC=mpicc CXX=mpicxx
}

src_configure() {
	use wxwidgets && setup-wxwidgets unicode

	local mycmakeargs=(
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
		-Denable-qt5=OFF
		-Denable-qt6=$(usex qt6)
		-Denable-qt6asqt=$(usex qt6)
		-Denable-json-sample=OFF # claims WebEngine, but just does not build w/o WebKit
		-Denable-pthread=$(usex threads)
		-Denable-pthr-widget=$(usex threads)
		-Denable-python=OFF
		-Denable-wx=$(usex wxwidgets)
		-Denable-zlib=$(usex zlib)
	)
	use hdf && mycmakeargs+=( -DHDF4_INCLUDE_DIR="${EPREFIX}/usr/include" )

	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc README* *.txt AUTHORS
	rm "${ED}"/usr/$(get_libdir)/*.a || die
	if use qt6 ; then
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
