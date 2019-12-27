# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER=3.0-gtk3
FORTRAN_NEEDED=fortran
PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake-utils flag-o-matic fortran-2 java-pkg-opt-2 python-single-r1 toolchain-funcs virtualx wxwidgets

DESCRIPTION="Multi-language scientific plotting library"
HOMEPAGE="http://plplot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0/14" # SONAME of libplplot.so
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="cairo cxx doc +dynamic examples fortran gd java jpeg latex lua ocaml octave pdf
	png python qhull qt5 shapefile svg tcl test threads tk truetype wxwidgets X"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	qt5? ( dynamic )
	test? ( latex )
	tk? ( tcl )
"

RESTRICT="
	!test? ( test )
	octave? ( test )
"

RDEPEND="
	cairo? ( x11-libs/cairo:0=[svg?,X] )
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
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
		qt5? ( dev-python/PyQt5[${PYTHON_USEDEP}] )
	)
	qhull? ( media-libs/qhull:0= )
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtprintsupport:5
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
	octave? ( >=dev-lang/swig-3.0.12 )
	python? ( dev-lang/swig )
	test? (
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.9.6-python.patch

	# Fedora patches
	"${FILESDIR}"/${PN}-5.15.0-ocaml-rpath.patch
	"${FILESDIR}"/${PN}-5.15.0-ieee.patch
	"${FILESDIR}"/${PN}-5.15.0-multiarch.patch
	"${FILESDIR}"/${PN}-5.15.0-ocaml.patch
	"${FILESDIR}"/${PN}-5.12.0-safe-string.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
	use java && java-pkg-opt-2_pkg_setup
	use fortran && fortran-2_pkg_setup
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
	local f
	while IFS="" read -d $'\0' -r f; do
		sed -i -e 's:${DATA_DIR}/examples:${DOC_DIR}/examples:g' "${f}" || die
	done < <(find "${S}" -name CMakeLists.txt -print0)

	sed -i \
		-e 's:${VERSION}::g' \
		-e "s:doc/\${PACKAGE}:doc/${PF}:" \
		cmake/modules/instdirs.cmake || die

	java-utils-2_src_prepare
}

src_configure() {
	# - don't build doc, it pulls in a whole stack of horrible dependencies
	# - Bindings:
	#   * Ada is a mess in Gentoo, don't use
	#   * D has been removed from Gentoo, don't use
	#   * Qt4 has been disabled, as it is deprecated and unsupported upstream
	# - DPLD_* drivers need to use ON/OFF instead of the usex defaults yes/no, as
	#   the testsuite performs a string comparison to determine which tests to run

	# Octave bindings now require C++11 support, #609980
	append-cxxflags -std=c++11

	local mycmakeargs=(
		# The build system does not honour CMAKE_INSTALL_LIBDIR as a
		# relative dir, which is against the spirit of GNUInstallDirs, #610066
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/$(get_libdir)

		## Features
		-DBUILD_DOC=OFF
		-DBUILD_DOX_DOC=OFF
		-DUSE_RPATH=OFF
		-DPREBUILT_DOC=$(usex doc)
		-DHAVE_SHAPELIB=$(usex shapefile)
		-DWITH_FREETYPE=$(usex truetype)
		-DPL_HAVE_PTHREAD=$(usex threads)
		-DPL_HAVE_QHULL=$(usex qhull)
		-DPLPLOT_USE_QT5=$(usex qt5)

		## Tests
		-DBUILD_TEST=$(usex test)

		## Bindings
		-DENABLE_ada=OFF
		-DENABLE_d=OFF
		-DENABLE_ocaml=$(usex ocaml)
		-DENABLE_pyqt4=OFF
		-DENABLE_cxx=$(usex cxx)
		-DENABLE_DYNDRIVERS=$(usex dynamic)
		-DENABLE_fortran=$(usex fortran)
		-DENABLE_java=$(usex java)
		-DENABLE_lua=$(usex lua)
		-DENABLE_octave=$(usex octave)
		-DENABLE_python=$(usex python)
		-DENABLE_qt=$(usex qt5)
		-DENABLE_tcl=$(usex tcl)
		-DENABLE_itcl=$(usex tcl)
		-DENABLE_tk=$(usex tk)
		-DENABLE_itk=$(usex tk)
		-DENABLE_wxwidgets=$(usex wxwidgets)

		## Drivers
		-DPLD_cgm=OFF
		-DPLD_gif=OFF
		-DPLD_jpeg=OFF
		-DPLD_plmeta=OFF
		-DPLD_png=OFF
		-DPLD_pstex=OFF
		-DPLD_wxpng=OFF
		-DPLD_mem=ON
		-DPLD_null=ON
		-DPLD_wingcc=ON
		# Cairo
		$(usex cairo "" "-DDEFAULT_NO_CAIRO_DEVICES=ON")
		-DPLD_epscairo=$(usex cairo ON OFF)
		-DPLD_extcairo=$(usex cairo ON OFF)
		-DPLD_memcairo=$(usex cairo ON OFF)
		-DPLD_pdfcairo=$(usex cairo ON OFF)
		-DPLD_pngcairo=$(usex cairo ON OFF)
		-DPLD_pscairo=$(usex cairo ON OFF)
		-DPLD_svgcairo=$(usex cairo ON OFF)
		-DPLD_xcairo=$(usex cairo ON OFF)
		# LaTeX
		-DPLD_ps=$(usex latex ON OFF)
		# PDF
		-DPLD_pdf=$(usex pdf ON OFF)
		# Qt
		-DPLD_aqt=$(usex qt5 ON OFF)
		-DPLD_bmpqt=$(usex qt5 ON OFF)
		-DPLD_epsqt=$(usex qt5 ON OFF)
		-DPLD_extqt=$(usex qt5 ON OFF)
		-DPLD_jpgqt=$(usex qt5 ON OFF)
		-DPLD_memqt=$(usex qt5 ON OFF)
		-DPLD_pdfqt=$(usex qt5 ON OFF)
		-DPLD_pngqt=$(usex qt5 ON OFF)
		-DPLD_ppmqt=$(usex qt5 ON OFF)
		-DPLD_qtwidget=$(usex qt5 ON OFF)
		-DPLD_svgqt=$(usex qt5 ON OFF)
		-DPLD_tiffqt=$(usex qt5 ON OFF)
		# SVG
		-DPLD_svg=$(usex svg ON OFF)
		# Tk
		-DPLD_ntk=$(usex tk ON OFF)
		-DPLD_tk=$(usex tk ON OFF)
		-DPLD_tkwin=$(usex tk ON OFF)
		# Truetype
		-DPLD_psttf=$(usex truetype ON OFF)
		# Wx
		-DPLD_wxwidgets=$(usex wxwidgets ON OFF)
		# X
		-DPLD_xfig=$(usex X ON OFF)
		-DPLD_xwin=$(usex X ON OFF)
	)

	use truetype && mycmakeargs+=(
		-DPL_FREETYPE_FONT_PATH="${EPREFIX}"/usr/share/fonts/freefont
	)
	use shapefile && mycmakeargs+=(
		-DSHAPELIB_INCLUDE_DIR="${EPREFIX}"/usr/include/libshp
	)
	use ocaml && mycmakeargs+=(
		-DOCAML_INSTALL_DIR="$(ocamlc -where)"
	)
	use python && mycmakeargs+=(
		-DENABLE_pyqt5=$(usex qt5)
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
		rm -r "${ED%/}"/usr/share/doc/${PF}/examples || die
	fi

	if use java; then
		java-pkg_dojar "${BUILD_DIR}"/examples/java/${PN}.jar
		java-pkg_regso "${EPREFIX}"/usr/$(get_libdir)/jni/plplotjavac_wrap.so
	fi
}
