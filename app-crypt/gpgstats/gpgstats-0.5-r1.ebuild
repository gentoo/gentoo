# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gpgstats/gpgstats-0.5-r1.ebuild,v 1.4 2009/07/15 22:27:07 arfrever Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="GPGstats calculates statistics on the keys in your key-ring"
HOMEPAGE="http://www.vanheusden.com/gpgstats/"
SRC_URI="http://www.vanheusden.com/gpgstats/${P}.tgz"
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
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" DEBUG= || die "emake failed"
}

src_install() {
	dobin gpgstats || die "dobin gpgstas failed"
}
