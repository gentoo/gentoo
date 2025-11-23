# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature xdg

DESCRIPTION="Powerful LaTeX-IDE"
HOMEPAGE="https://xm1math.net/texmaker/"
SRC_URI="https://xm1math.net/texmaker/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="webengine"

# dev-qt/qtbase slot op: Qt6::CorePrivate, includes private/qabstractitemmodel_p.h
RDEPEND="
	app-text/hunspell:=
	app-text/texlive-core
	dev-qt/qt5compat:6
	dev-qt/qtbase:6=[concurrent,gui,network,widgets,xml]
	dev-qt/qtdeclarative:6
	virtual/latex-base
	webengine? ( dev-qt/qtwebengine:6[widgets] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.0-unbundle_hunspell_synctex.patch
	"${FILESDIR}"/${PN}-6.0.0-unforce_webengine.patch
	"${FILESDIR}"/${PN}-6.0.0-fix_lto_mismatch.patch
)

src_prepare() {
	# -> app-text/hunspell
	rm -r 3rdparty/hunspell || die
	sed -e '/3rdparty\/hunspell/d' \
		-i CMakeLists.txt || die

	# -> app-text/texlive-core
	rm -r 3rdparty/synctex || die
	sed -e '/3rdparty\/synctex/d' \
		-i CMakeLists.txt || die

	# fix helpdir
	sed -e "s:texmaker/usermanual_:doc/${PF}/html/usermanual_:" \
		-e "s:texmaker/latexhelp.html:doc/${PF}/html/latexhelp.html:" \
		-i src/texmaker.cpp || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINTERNALBROWSER=$(usex webengine)
	)

	cmake_src_configure
}

src_install() {
	local DOCS+=( datas/dictionaries/*README*.txt datas/CHANGELOG.txt AUTHORS )
	local HTML_DOCS=( datas/doc/. )

	cmake_src_install

	# already installed in docdir
	rm "${ED}"/usr/share/${PN}/{*.html,*.png,*.txt,AUTHORS,COPYING} || die
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "conversion tools and print support" app-text/ghostscript-gpl
	optfeature "PostScript tools" app-text/psutils
	optfeature "graphic tools" media-libs/netpbm
	optfeature "integration of R code (Sweave)" dev-lang/R
	optfeature "automation" dev-tex/latexmk
	optfeature "XeLaTex engine" dev-texlive/texlive-xetex
	optfeature "the vector graphics language (.asy)" media-gfx/asymptote
}
