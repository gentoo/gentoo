# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER="3.0-gtk3"
PLOCALES="ca cs da de el en es fi fr gl hu it ja kab nb pl pt_BR ru tr uk zh_CN zh_TW"
inherit cmake l10n wxwidgets xdg

DESCRIPTION="Graphical frontend to Maxima, using the wxWidgets toolkit"
HOMEPAGE="https://wxmaxima-developers.github.io/wxmaxima/"
SRC_URI="https://github.com/wxMaxima-developers/wxmaxima/archive/Version-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc cppcheck +openmp"
S="${WORKDIR}"/${PN}-Version-${PV}
DOCS=""
HTML_DOCS=( "${BUILD_DIR}"/info/. )
RESTRICT="test"

DEPEND="app-text/pandoc
		dev-libs/libxml2:2
		x11-libs/wxGTK:${WX_GTK_VER}"
RDEPEND="${DEPEND}
		media-fonts/jsmath
		sci-visualization/gnuplot[wxwidgets]
		sci-mathematics/maxima"
BDEPEND="openmp?	(	sys-devel/gcc[openmp] )
		cppcheck?	(	dev-util/cppcheck )
		doc?		(	app-doc/doxygen[dot]
						app-text/pandoc
						dev-texlive/texlive-luatex )"

src_configure() {
	local mycmakeargs=(
		-DWXM_USE_OPENMP=$(usex openmp)
		-DWXM_USE_CPPCHECK=$(usex cppcheck)
	)

	cmake_src_configure
}

src_prepare() {
	# wrong documentation installation path
	sed -i \
		-e "s/doc\/wxmaxima/doc\/wxmaxima-$PV/g" \
	CMakeLists.txt info/CMakeLists.txt || die
	sed -i \
		-e "s/wxmaxima-${PV}/wxmaxima-${PV}\/html/g" \
	info/CMakeLists.txt || die

	setup-wxwidgets
	cmake_src_prepare

	# locales
	rm_po() {
		rm "${S}"/locales/wxMaxima/${1}.po || die "rm ${1}.po failed"
		rm -f "${S}"/locales/manual/${1}.po
		rm -f "${S}"/locales/wxwin/${1}.po
		rm -f "${S}"/info/${PN}.${1}.md
		rm -f "${S}"/info/${PN}.${1}.html
	}
	l10n_find_plocales_changes "${S}"/locales/wxMaxima '' '.po'
	l10n_for_each_disabled_locale_do rm_po
}

src_compile() {
	cmake_src_compile

	if use doc ; then
		ebegin "Compiling source documentation"
			eninja -C "${BUILD_DIR}" doxygen
		eend
	fi
}

src_install() {
	docompress -x /usr/share/doc/${PF}
	cmake_src_install

	rm -rvf	"${D}"/usr/share/doc/${P}/html/CMakeFiles \
			"${D}"/usr/share/doc/${P}/html/cmake_install.cmake

	if use doc ; then
		ebegin "Installing source file documentation"
			docinto html/source
			dodoc -r "${BUILD_DIR}"/Doxygen/html/.
		eend
	fi
}

pkg_postinst() {
	if use doc ; then
		elog "Documentation about the source code functions have been"
		elog "installed in /usr/share/doc/${P}/html/source/"
	fi
}
