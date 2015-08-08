# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils qt4-r2

DESCRIPTION="A program to create compositions from video files"
HOMEPAGE="http://code.google.com/p/videocut/"
SRC_URI="http://${PN}.googlecode.com/files/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtgui:4
	dev-qt/qtsvg:4
	media-libs/xine-lib"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}.orig

PATCHES=( "${FILESDIR}"/01-fix-hardened-ftbfs.diff )

src_compile() {
	emake || die
	lrelease i18n/*.ts
}

src_install() {
	exeinto /usr/libexec
	doexe build/result/${PN} || die
	dobin "${FILESDIR}"/${PN} || die
	insinto /usr/share/${PN}/i18n
	doins -r i18n/*.qm || die
	domenu ${PN}.desktop
	doicon videocut.svg
	dodoc ABOUT AUTHORS THANKSTO
}
