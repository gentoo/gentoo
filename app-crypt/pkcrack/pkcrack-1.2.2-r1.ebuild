# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/pkcrack/pkcrack-1.2.2-r1.ebuild,v 1.1 2012/12/22 00:55:28 alonbl Exp $

EAPI="4"
inherit toolchain-funcs

DESCRIPTION="PkZip cipher breaker"
HOMEPAGE="http://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack.html"
SRC_URI="http://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/${P}.tar.gz"

LICENSE="pkcrack"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

DEPEND="test? ( app-arch/zip[crypt] )"
RDEPEND="!<app-text/html-xml-utils-5.3"

src_prepare() {
	cd "${S}/src"
	sed -i -e "s/^CC=.*/CC=$(tc-getCC)/" \
		-e "/^CFLAGS=.*/d" \
		-e "s/CFLAGS/LDFLAGS/" \
		Makefile
	sed -i -e "s:void main:int main:" *.c
}

src_compile() {
	cd "${S}/src"
	emake
}

src_test() {
	cd "${S}/test"
	make CC="$(tc-getCC)" all
}

src_install() {
	cd "${S}/src"
	dobin pkcrack zipdecrypt findkey makekey
	newbin extract "$PN-extract"
	dodoc "${S}/doc/"*
}

pkg_postinst() {
	elog "Author DEMANDS :-) a postcard be sent to:"
	elog
	elog "    Peter Conrad"
	elog "    Am Heckenberg 1"
	elog "    56727 Mayen"
	elog "    Germany"
	elog
	elog "See: http://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/pkcrack-readme.html"

	ewarn
	ewarn "Due to file collision, extract utility was renamed to $PN-extract,"
	ewarn "see bug#247394"
}
