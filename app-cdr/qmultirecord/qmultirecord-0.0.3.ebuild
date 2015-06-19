# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/qmultirecord/qmultirecord-0.0.3.ebuild,v 1.4 2013/03/02 19:13:24 hwoarang Exp $

EAPI=2
inherit eutils qt4-r2

DESCRIPTION="CD and DVD recording frontend for cdrtools and dvd+rw-tools"
HOMEPAGE="http://qt-apps.org/content/show.php/qmultirecord?content=106254"
SRC_URI="http://qt-apps.org/CONTENT/content-files/106254-${P}_fix.tar.bz2 ->
${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtcore:4"
RDEPEND="${COMMON_DEPEND}
	virtual/eject
	app-cdr/dvd+rw-tools
	virtual/cdrtools"
DEPEND="${COMMON_DEPEND}"

PATCHES=( "${FILESDIR}/${P}-langinfo_h.patch" )

src_install() {
	exeinto /usr/libexec
	doexe bin/*.bin || die "doexe failed"
	insinto /usr/share/${PN}
	doins bin/*.txt || die "doins failed"
	dobin "${FILESDIR}"/${PN} || die "dobin failed"
	newicon src/icons/burn_on.png ${PN}.png
	make_desktop_entry ${PN} QMultirecorder ${PN} "Utility;Qt;DiscBurning"
	dodoc ChangeLog README TODO bin/*.example || die "dodoc failed"
}
