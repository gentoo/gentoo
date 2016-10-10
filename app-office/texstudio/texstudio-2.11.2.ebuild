# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit fdo-mime prefix qmake-utils

DESCRIPTION="Free cross-platform LaTeX editor (fork from texmakerX)"
HOMEPAGE="http://texstudio.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/TeXstudio%20${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="video qt4 +qt5"

REQUIRED_USE="^^ ( qt4 qt5 )"

COMMON_DEPEND="
	app-text/hunspell
	app-text/poppler:=[qt4?,qt5?]
	>=dev-libs/quazip-0.7.1[qt4?,qt5?]
	dev-qt/qtsingleapplication[X,qt4?,qt5?]
	x11-libs/libX11
	x11-libs/libXext
	qt4? (
		dev-qt/designer:4
		>=dev-qt/qtgui-4.8.5:4
		>=dev-qt/qtcore-4.6.1:4
		>=dev-qt/qtscript-4.6.1:4
		>=dev-qt/qtsvg-4.6.1:4
		>=dev-qt/qttest-4.6.1:4
	)
	qt5? (
		dev-qt/designer:5
		dev-qt/qtcore:5
		dev-qt/qtconcurrent:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtscript:5
		dev-qt/qtsvg:5
		dev-qt/qttest:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	video? ( media-libs/phonon[qt4?,qt5?] )"
RDEPEND="${COMMON_DEPEND}
	virtual/latex-base
	app-text/psutils
	app-text/ghostscript-gpl
	media-libs/netpbm"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

S=${WORKDIR}

src_prepare() {
	find hunspell quazip utilities/poppler-data qtsingleapplication -delete || die

	if use video; then
		sed "/^PHONON/s:$:true:g" -i ${PN}.pro || die
	fi

	sed \
		-e '/qtsingleapplication.pri/d' \
		-i ${PN}.pro || die

#	cat >> ${PN}.pro <<- EOF
#	exists(texmakerx_my.pri):include(texmakerx_my.pri)
#	EOF

	cp "${FILESDIR}"/texmakerx_my.pri ${PN}.pri || die
	eprefixify ${PN}.pri
}

src_configure() {
	if use qt5; then
		eqmake5 USE_SYSTEM_HUNSPELL=1 USE_SYSTEM_QUAZIP=1
	else
		eqmake4 USE_SYSTEM_HUNSPELL=1 USE_SYSTEM_QUAZIP=1
	fi
}

src_install() {
	local i
	for i in 16x16 22x22 32x32 48x48 64x64 128x128; do
		insinto /usr/share/icons/hicolor/${i}/apps
		newins utilities/${PN}${i}.png ${PN}.png
	done
	emake DESTDIR="${D}" INSTALL_ROOT="${ED}" install
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
