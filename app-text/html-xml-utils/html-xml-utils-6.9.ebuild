# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/html-xml-utils/html-xml-utils-6.9.ebuild,v 1.1 2015/06/17 08:48:20 monsieurp Exp $

EAPI=5

DESCRIPTION="A number of simple utilities for manipulating HTML and XML files"
SRC_URI="http://www.w3.org/Tools/HTML-XML-utils/${P}.tar.gz"
HOMEPAGE="http://www.w3.org/Tools/HTML-XML-utils/"

LICENSE="W3C"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e "/doc_DATA = COPYING/d" -i Makefile.in || die
}
