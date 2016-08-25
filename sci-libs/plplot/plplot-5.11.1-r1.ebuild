# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"
FORTRAN_NEEDED=fortran
PYTHON_COMPAT=( python2_7 )
VIRTUALX_REQUIRED=test

inherit eutils fortran-2 cmake-utils python-single-r1 toolchain-funcs \
	virtualx wxwidgets java-pkg-opt-2 multilib

DESCRIPTION="Multi-language scientific plotting library"
HOMEPAGE="http://plplot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0/12"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="ada cairo cxx doc +dynamic examples fortran gd java jpeg latex lua
	ocaml octave pdf pdl png python qhull qt4 shapefile svg tcl test
	threads tk truetype wxwidgets X"

RDEPEND="
	ada? ( virtual/gnat:* )
	cairo? ( x11-libs/cairo:0=[svg?,X?] )
	gd? ( media-libs/gd:2=[jpeg?,png?] )
	java? ( >=virtual/jre-1.5:* )
	latex? (
		app-text/ghostscript-gpl
		virtual/latex-base
	)
	lua? ( dev-lang/lua:0= )
	ocaml? (
		dev-lang/ocaml
		dev-ml/camlidl
		cairo? ( dev-ml/cairo-ocaml[gtk] )
	)
	octave? ( sci-mathematics/octave:0= )
	pdf? ( media-libs/libharu:0= )
	pdl? (
		dev-perl/PDL
		dev-perl/XML-DOM
	)
	python? (
		dev-python/numpy[${PYTHON_USEDEP}]
		qt4? ( dev-python/PyQt4[${PYTHON_USEDEP}] )
	)
	qhull? ( media-libs/qhull:0= )
	qt4? (
		dev-qt/qtgui:4=
		dev-qt/qtsvg:4=
	)
	shapefile? ( sci-libs/shapelib:0= )
	tcl? (
		dev-lang/tcl:0=
		dev-tcltk/itcl:0=
		tk? (
			dev-lang/tk:0=
			dev-tcltk/itk
		)
	)
	truetype? (
		media-fonts/freefont
		media-libs/lasi:0=
		gd? ( media-libs/gd:2=[truetype] )
	)
	wxwidgets? (
		x11-libs/wxGTK:${WX_GTK_VER}=[X]
		x11-libs/agg:0=[truetype?]
	)
	X? (
		x11-libs/libX11:0=
		x11-libs/libXau:0=
		x11-libs/libXdmcp:0=
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	java? (
		>=virtual/jdk-1.5
		dev-lang/swig
	)
	ocaml? ( dev-ml/findlib )
	octave? ( >=dev-lang/swig-2.0.12 )
	python? ( dev-lang/swig )
	test? (
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc
	)"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ) qt4? ( dynamic ) test? ( latex ) tk? ( tcl )"

PATCHES=(
	"${FILESDIR}"/${PN}-5.9.6-python.patch
	"${FILESDIR}"/${PN}-5.11.0-ocaml.patch
	"${FILESDIR}"/${PN}-5.11.0-octave.patch
	"${FILESDIR}"/${PN}-5.11.0-multiarch.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
	java-pkg-opt-2_pkg_setup
	fortran-2_pkg_setup
}

src_prepare() {
	use wxwidgets && need-wxwidgets unicode
	cmake-utils_src_prepare
	# avoid installing license
	sed -i -e '/COPYING.LIB/d' CMakeLists.txt || die
	# prexify hard-coded /usr/include in cmake modules
	sed -i \
		-e "s:/usr/include:${EPREFIX}/usr/include:g" \
		-e "s:/usr/lib:${EPREFIX}/usr/$(get_libdir):g" \
		-e "s:/usr/share:${EPREFIX}/usr/share:g" \
		cmake/modules/*.cmake || die
	# change default install directories for doc and examples
	sed -i \
		-e 's:${DATA_DIR}/examples:${DOC_DIR}/examples:g' \
		$(find "${S}" -name CMakeLists.txt) || die
	sed -i \
		-e 's:${VERSION}::g' \
		-e "s:doc/\${PACKAGE}:doc/${PF}:" \
		cmake/modules/instdirs.cmake || die
	java-utils-2_src_prepare
}

src_configure() {
	# don't build doc, it brings a whole lot of horrible dependencies

	# -DPLPLOT_USE_QT5=ON
	# Not recomended by upstream, check next release

	local mycmakeargs=(
		-DPLD_plmeta=ON
		-DPLD_cgm=ON
		-DTEST_DYNDRIVERS=OFF
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DENABLE_d=OFF
		-DBUILD_DVI=OFF
		-DDOX_DOC=OFF
		-DBUILD_DOC=OFF
		-DUSE_RPATH=OFF
		-DPLD_wxpng=OFF
		$(cmake-utils_use doc PREBUILT_DOC)
		$(cmake-utils_use_build test)
		$(cmake-utils_use_has python NUMPY)
		$(cmake-utils_use_has shapefile SHAPELIB)
		$(cmake-utils_use_with truetype FREETYPE)
		$(cmake-utils_use_enable ada)
		$(cmake-utils_use_enable cxx)
		$(cmake-utils_use_enable dynamic DYNDRIVERS)
		$(cmake-utils_use_enable fortran f77)
		$(cmake-utils_use_enable java)
		$(cmake-utils_use_enable lua)
		$(cmake-utils_use_enable ocaml)
		$(cmake-utils_use_enable octave)
		$(cmake-utils_use_enable pdl)
		$(cmake-utils_use_enable python)
		$(cmake-utils_use_enable qt4 qt)
		$(cmake-utils_use_enable tcl)
		$(cmake-utils_use_enable tcl itcl)
		$(cmake-utils_use_enable tk)
		$(cmake-utils_use_enable tk itk)
		$(cmake-utils_use_enable wxwidgets)
		$(cmake-utils_use threads PL_HAVE_PTHREAD)
		$(cmake-utils_use qhull PL_HAVE_QHULL)
		$(cmake-utils_use qt4 PLD_aqt)
		$(cmake-utils_use qt4 PLD_bmpqt)
		$(cmake-utils_use qt4 PLD_epsqt)
		$(cmake-utils_use qt4 PLD_extqt)
		$(cmake-utils_use qt4 PLD_jpgqt)
		$(cmake-utils_use qt4 PLD_memqt)
		$(cmake-utils_use qt4 PLD_pdfqt)
		$(cmake-utils_use qt4 PLD_pngqt)
		$(cmake-utils_use qt4 PLD_ppmqt)
		$(cmake-utils_use qt4 PLD_svgqt)
		$(cmake-utils_use qt4 PLD_qtwidget)
		$(cmake-utils_use qt4 PLD_tiffqt)
		$(cmake-utils_use cairo PLD_extcairo)
		$(cmake-utils_use cairo PLD_memcairo)
		$(cmake-utils_use cairo PLD_pdfcairo)
		$(cmake-utils_use cairo PLD_pngcairo)
		$(cmake-utils_use cairo PLD_pscairo)
		$(cmake-utils_use cairo PLD_svgcairo)
		$(cmake-utils_use cairo PLD_wincairo)
		$(cmake-utils_use cairo PLD_xcairo)
		$(usex cairo "" "-DDEFAULT_NO_CAIRO_DEVICES=ON")
		$(cmake-utils_use tk PLD_ntk)
		$(cmake-utils_use tk PLD_tk)
		$(cmake-utils_use tk PLD_tkwin)
		$(cmake-utils_use gd PLD_gif)
		$(cmake-utils_use gd PLD_jpeg)
		$(cmake-utils_use gd PLD_png)
		$(cmake-utils_use pdf PLD_pdf)
		$(cmake-utils_use latex PLD_ps)
		$(cmake-utils_use latex PLD_pstex)
		$(cmake-utils_use truetype PLD_psttf)
		$(cmake-utils_use svg PLD_svg)
		$(cmake-utils_use wxwidgets PLD_wxwidgets)
		$(cmake-utils_use X PLD_xwin)
	)

	[[ $(tc-getFC) != *g77 ]] && \
		mycmakeargs+=(
		$(cmake-utils_use_enable fortran f95)
	)

	use truetype && mycmakeargs+=(
		-DPL_FREETYPE_FONT_PATH:PATH="${EPREFIX}/usr/share/fonts/freefont"
	)
	use shapefile && mycmakeargs+=(
		-DSHAPELIB_INCLUDE_DIR="${EPREFIX}/usr/include/libshp"
	)
	use ocaml && mycmakeargs+=(
		-DOCAML_INSTALL_DIR="$(ocamlc -where)"
	)
	use python && mycmakeargs+=(
		$(cmake-utils_use_enable qt4 pyqt4)
	)

	cmake-utils_src_configure

	# clean up bloated pkg-config files (help linking properly on prefix)
	sed -i \
		-e "/Cflags/s:-I\(${EPREFIX}\|\)/usr/include[[:space:]]::g" \
		-e "/Libs/s:-L\(${EPREFIX}\|\)/usr/lib\(64\|\)[[:space:]]::g" \
		-e "s:${LDFLAGS}::g" \
		"${BUILD_DIR}"/pkgcfg/*pc || die
}

src_test() {
	virtx cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
	else
		rm -r "${ED}"/usr/share/doc/${PF}/examples || die
	fi
	if use java; then
		java-pkg_dojar "${BUILD_DIR}"/examples/java/${PN}.jar
		java-pkg_regso "${ED}"/usr/$(get_libdir)/jni/plplotjavac_wrap.so
	fi
}
