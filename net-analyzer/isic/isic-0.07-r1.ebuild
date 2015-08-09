# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="IP Stack Integrity Checker"
HOMEPAGE="http://isic.sourceforge.net/"
SRC_URI="mirror://sourceforge/isic/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="net-libs/libnet:1.1"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog README )

src_prepare() {
	# Add two missing includes
	echo "#include <netinet/udp.h>" >> isic.h || die
	echo "#include <netinet/tcp.h>" >> isic.h || die

	# Install man pages in /usr/share/man
	sed -i -e 's|/man/man1|/share&|g' Makefile.in || die

	tc-export CC
}

src_configure() {
	# Build system does not know about DESTDIR
	econf --prefix="${D}/usr" --exec_prefix="${D}/usr"
}
