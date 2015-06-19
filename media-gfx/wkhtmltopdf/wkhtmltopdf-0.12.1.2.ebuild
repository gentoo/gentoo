# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/wkhtmltopdf/wkhtmltopdf-0.12.1.2.ebuild,v 1.1 2014/11/27 05:03:51 radhermit Exp $

EAPI=5

inherit qt4-r2 multilib eutils

DESCRIPTION="Convert html to pdf (and various image formats) using webkit"
HOMEPAGE="http://wkhtmltopdf.org/ https://github.com/wkhtmltopdf/wkhtmltopdf/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-qt/qtgui:4
	dev-qt/qtwebkit:4
	dev-qt/qtcore:4
	dev-qt/qtsvg:4
	dev-qt/qtxmlpatterns:4"
DEPEND="${RDEPEND}"

src_prepare() {
	# fix install paths and don't precompress man pages
	epatch "${FILESDIR}"/${P}-manpages.patch

	sed -i "s:\(INSTALLBASE/\)lib:\1$(get_libdir):" src/lib/lib.pro || die
}

src_configure() {
	eqmake4 INSTALLBASE=/usr
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc AUTHORS CHANGELOG* README.md
	use examples && dodoc -r examples
}
