# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/html2text/html2text-1.3.2a.ebuild,v 1.9 2012/08/19 15:58:50 armin76 Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A HTML to text converter"
HOMEPAGE="http://www.mbayer.de/html2text/"
SRC_URI="http://www.mbayer.de/html2text/downloads/${P}.tar.gz
	http://www.mbayer.de/html2text/downloads/patch-utf8-${P}.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${P}.tar.gz
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-compiler.patch
	epatch "${FILESDIR}"/${P}-urlistream-get.patch
	epatch "${DISTDIR}"/patch-utf8-${P}.diff
}

src_configure() {
	tc-export CXX
	default
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" DEBUG="${CXXFLAGS}"
}

src_install() {
	dobin html2text
	doman html2text.1.gz html2textrc.5.gz
	dodoc CHANGES CREDITS KNOWN_BUGS README TODO
}
