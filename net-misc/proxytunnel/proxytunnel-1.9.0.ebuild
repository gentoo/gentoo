# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/proxytunnel/proxytunnel-1.9.0.ebuild,v 1.5 2014/01/26 21:01:17 vikraman Exp $

EAPI="5"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Connect stdin and stdout to a server somewhere on the network, through a standard HTTPS proxy"
HOMEPAGE="https://github.com/proxytunnel/proxytunnel/ http://proxytunnel.sourceforge.net/"
SRC_URI="mirror://sourceforge/proxytunnel/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static"

RDEPEND="dev-libs/openssl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i -e 's/libssl/libssl libcrypto/' Makefile || die "Sed failed!"
}

src_compile() {
	use static && append-ldflags -static
	emake CC="$(tc-getCC)" || die
}

src_install() {
	emake install PREFIX="${EPREFIX}"/usr DESTDIR="${D}" || die
	dodoc CHANGES CREDITS INSTALL KNOWN_ISSUES LICENSE.txt README RELNOTES TODO
}
