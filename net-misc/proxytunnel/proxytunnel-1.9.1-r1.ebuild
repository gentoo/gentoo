# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Connect stdin and stdout to a server somewhere on the network, through a standard HTTPS proxy"
HOMEPAGE="https://github.com/proxytunnel/proxytunnel/ http://proxytunnel.sourceforge.net/"
SRC_URI="https://github.com/proxytunnel/proxytunnel/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="static"

RDEPEND="dev-libs/openssl:="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/asciidoc
	app-text/xmlto
	"

src_prepare() {
	sed -i -e 's/libssl/libssl libcrypto/' Makefile || die "Sed failed!"
	epatch "${FILESDIR}"/${PN}-allowTLS.patch
}

src_compile() {
	use static && append-ldflags -static
	emake CC="$(tc-getCC)" || die
}

src_install() {
	emake install prefix="${EPREFIX}"/usr DESTDIR="${D}" || die
	dodoc CHANGES CREDITS INSTALL KNOWN_ISSUES LICENSE.txt README RELNOTES TODO
}
