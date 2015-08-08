# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qmake-utils readme.gentoo

DESCRIPTION="A nice LaTeX-IDE"
HOMEPAGE="http://www.xm1math.net/texmaker/"
SRC_URI="http://www.xm1math.net/texmaker/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="+qt4 qt5"

REQUIRED_USE="^^ ( qt4 qt5 )"

COMMON_DEPEND="
	app-text/hunspell
	app-text/poppler:=[qt4?,qt5?]
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXext
	dev-qt/qtsingleapplication[X,qt4?,qt5?]
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtcore:4
		dev-qt/qtscript:4
		dev-qt/qtwebkit:4
		)
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtgui:5
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtscript:5
		dev-qt/qtwebkit:5[printsupport]
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		)
"
RDEPEND="${COMMON_DEPEND}
	virtual/latex-base
	app-text/psutils
	app-text/ghostscript-gpl
	media-libs/netpbm
	qt4? ( app-i18n/ibus-qt )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-4.1-unbundle.patch )

DOCS=( utilities/AUTHORS utilities/CHANGELOG.txt )
HTML_DOCS=( doc/. )

src_prepare() {
	find singleapp hunspell -delete || die

	epatch "${PATCHES[@]}"

	cat >> ${PN}.pro <<- EOF
	exists(texmakerx_my.pri):include(texmakerx_my.pri)
	EOF

	cp "${FILESDIR}"/texmakerx_my.pri . || die

	sed \
		-e '/^#include/s:hunspell/::g' \
		-e '/^#include/s:singleapp/::g' \
		-i *.cpp *.h || die

	DOC_CONTENTS="A user manual with many screenshots is available at:
	${EPREFIX}/usr/share/${PN}/usermanual_en.html"
}

src_configure() {
	local myeqmakeargs=(
		${PN}.pro
		PREFIX="${EPREFIX}/usr"
		DESKTOPDIR="${EPREFIX}/usr/share/applications"
		ICONDIR="${EPREFIX}/usr/share/pixmaps"
		)
	if use qt4; then
		eqmake4 ${myeqmakeargs[@]}
	else
		eqmake5 ${myeqmakeargs[@]}
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
	readme.gentoo_create_doc
}
