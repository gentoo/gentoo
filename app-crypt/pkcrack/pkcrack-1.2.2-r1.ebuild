# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="PkZip cipher breaker"
HOMEPAGE="https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack.html"
SRC_URI="https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/${P}.tar.gz"

LICENSE="pkcrack"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="!<app-text/html-xml-utils-5.3"
BDEPEND="test? ( app-arch/zip[crypt] )"

DOCS=(
	doc/KNOWN_BUGS
	doc/appnote.iz.txt
	doc/README.W32
	doc/pkzip.ps.gz
	doc/CHANGES
	doc/LIESMICH
	doc/README.html
	doc/README
)

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

src_compile() {
	cd src
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${LDFLAGS}" all
}

src_test() {
	cd test
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${LDFLAGS}" all
}

src_install() {
	einstalldocs
	cd src
	dobin pkcrack zipdecrypt findkey makekey
	newbin extract "$PN-extract"
}

pkg_postinst() {
	ewarn "Due to file collision, extract utility was renamed to $PN-extract,"
	ewarn "see bug#247394"
}
