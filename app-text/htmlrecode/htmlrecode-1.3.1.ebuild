# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/htmlrecode/htmlrecode-1.3.1.ebuild,v 1.1 2012/04/18 19:12:31 floppym Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Recodes HTML file using a new character set"
HOMEPAGE="http://bisqwit.iki.fi/source/htmlrecode.html"
SRC_URI="http://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=sys-apps/sed-4"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/${P}-ar.patch"
	touch .depend argh/.depend
}

src_configure() {
	:
}

src_compile() {
	local makeopts=(
		AR="$(tc-getAR)"
		CPPDEBUG=
		CXX="$(tc-getCXX)"
		CXXFLAGS="${CXXFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)
	emake "${makeopts[@]}" -C argh libargh.a
	emake "${makeopts[@]}" htmlrecode
}

src_install() {
	dobin htmlrecode
	dohtml README.html
}
