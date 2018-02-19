# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils qmake-utils readme.gentoo-r1

DESCRIPTION="A nice LaTeX-IDE"
HOMEPAGE="http://www.xm1math.net/texmaker/"
SRC_URI="http://www.xm1math.net/texmaker/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

COMMON_DEPEND="
	app-text/hunspell
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXext
	app-text/poppler:=[qt5(+)]
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtlockedfile
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtsingleapplication[X,qt5(+)]
	dev-qt/qtwebkit:5[printsupport]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
RDEPEND="${COMMON_DEPEND}
	app-text/ghostscript-gpl
	app-text/psutils
	media-libs/netpbm
	virtual/latex-base"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-unbundle-hunspell-singleapp.patch"
)

DOCS=( utilities/AUTHORS utilities/CHANGELOG.txt )
HTML_DOCS=( doc/. )

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
