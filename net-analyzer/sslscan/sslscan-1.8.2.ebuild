# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sslscan/sslscan-1.8.2.ebuild,v 1.8 2013/12/05 13:28:21 polynomial-c Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Fast SSL port scanner"
HOMEPAGE="http://sourceforge.net/projects/sslscan/"
SRC_URI="mirror://sourceforge/sslscan/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# Depend on -bindist since sslscan unconditionally requires elliptic
# curve support, bug 491102
DEPEND="dev-libs/openssl:0[-bindist]"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin sslscan
	doman sslscan.1
	dodoc Changelog
}
