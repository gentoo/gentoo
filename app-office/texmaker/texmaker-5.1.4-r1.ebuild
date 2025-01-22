# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils readme.gentoo-r1 xdg

DESCRIPTION="Powerful LaTeX-IDE"
HOMEPAGE="https://xm1math.net/texmaker/"
SRC_URI="https://xm1math.net/texmaker/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~amd64-linux ~x86-linux"
IUSE=""

# dev-qt/qtcore slot op: includes private/qabstractitemmodel_p.h
COMMON_DEPEND="
	app-text/hunspell:=
	app-text/poppler[qt5]
	dev-qt/qtcore:5=
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtlockedfile
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsingleapplication[X,qt5(+)]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXext
"
RDEPEND="${COMMON_DEPEND}
	app-text/ghostscript-gpl
	app-text/psutils
	media-libs/netpbm
	virtual/latex-base
"
DEPEND="${COMMON_DEPEND}
	dev-qt/qtconcurrent:5
"
BDEPEND="virtual/pkgconfig"

DOCS=( utilities/AUTHORS utilities/CHANGELOG.txt )
HTML_DOCS=( doc/. )

PATCHES=( "${FILESDIR}/${PN}-5.1-unbundle-hunspell-singleapp.patch" )

src_prepare() {
	default

	find singleapp hunspell -delete || die

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
		QT_MAJOR_VERSION=5
		INTERNALBROWSER=no # bug 926654, just making sure
		PREFIX="${EPREFIX}/usr"
		DESKTOPDIR="${EPREFIX}/usr/share/applications"
		ICONDIR="${EPREFIX}/usr/share/pixmaps"
	)
	eqmake5 ${myeqmakeargs[@]}
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
	readme.gentoo_create_doc
}
