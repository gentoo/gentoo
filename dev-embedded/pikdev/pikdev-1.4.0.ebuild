# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/pikdev/pikdev-1.4.0.ebuild,v 1.3 2014/08/10 20:04:09 slyfox Exp $

EAPI=5

inherit qt4-r2 eutils

DESCRIPTION="Simple graphic IDE for the development of PIC-based applications"
HOMEPAGE="http://pikdev.free.fr/"
SRC_URI="http://pikdev.free.fr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qt3support:4
	dev-qt/qtwebkit:4"
RDEPEND="${DEPEND}
	>=dev-embedded/gputils-1.0.0"

S="${WORKDIR}/${P}/src"

src_prepare() {
	rm pkp.pro || die 'rm failed'  # TODO: support pkp, maybe with a separated package

	qt4-r2_src_prepare
}

src_install() {
	qt4-r2_src_install

	doicon icons/256/pikdev-app-v4.png
	make_desktop_entry pikdev 'PIKdev for Qt4' pikdev-app-v4
	dosym "${P}" "/usr/bin/${PN}"
}

pkg_postinst() {
	elog "Additional packages that you may want to install:"
	elog
	elog "- dev-embedded/cpik - C compiler for PIC18 devices"
	elog "- dev-embedded/pk2cmd - Microchip PicKit2 PIC programmer support"
	elog
}
