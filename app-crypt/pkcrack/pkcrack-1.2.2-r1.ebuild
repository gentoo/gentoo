# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
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

DOCS=(
	../doc/KNOWN_BUGS
	../doc/appnote.iz.txt
	../doc/README.W32
	../doc/pkzip.ps.gz
	../doc/CHANGES
	../doc/LIESMICH
	../doc/README.html
	../doc/README
)

S="${WORKDIR}/${P}/src"

src_prepare() {
	default
	sed -i -e "s/^CC=.*/CC=$(tc-getCC)/" \
		-e "/^CFLAGS=.*/d" \
		-e "s/CFLAGS/LDFLAGS/" \
		Makefile
	sed -i -e "s:void main:int main:" *.c
}

src_test() {
	cd "${S}/../test"
	make CC="$(tc-getCC)" all
}

src_install() {
	einstalldocs
	dobin pkcrack zipdecrypt findkey makekey
	newbin extract "$PN-extract"
}

pkg_postinst() {
	ewarn "Due to file collision, extract utility was renamed to $PN-extract,"
	ewarn "see bug#247394"
}
