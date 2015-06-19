# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/shoutcast-search/shoutcast-search-0.3.ebuild,v 1.3 2011/04/11 21:50:29 arfrever Exp $

EAPI="3"

inherit distutils

DESCRIPTION="A command-line tool for searching SHOUTcast stations"
HOMEPAGE="http://www.k2h.se/code/shoutcast-search.html"
SRC_URI="http://www.k2h.se/code/dl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.4"
DEPEND="${RDEPEND}
	dev-python/setuptools"

src_install() {
	distutils_src_install
	dobin ${PN} || die "dobin failed"
	doman ${PN}.1 || die "doman failed"
	dodoc documentation.md || die "dodoc failed"
}
