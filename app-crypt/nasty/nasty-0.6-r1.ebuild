# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/nasty/nasty-0.6-r1.ebuild,v 1.6 2014/08/10 02:27:01 patrick Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Proof-of-concept GPG passphrase recovery tool"
HOMEPAGE="http://www.vanheusden.com/nasty/"
SRC_URI="http://www.vanheusden.com/nasty/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="app-crypt/gpgme"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-flags.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" DEBUG= || die "emake failed"
}

src_install() {
	dobin nasty || die "dobin nasty failed"
	dodoc readme.txt
}
