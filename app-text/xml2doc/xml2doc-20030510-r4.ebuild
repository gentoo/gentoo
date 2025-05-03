# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Tool to convert simple XML to a variety of formats (pdf, html, txt, manpage)"
HOMEPAGE="http://xml2doc.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc ppc64 sparc x86"

DEPEND="dev-libs/libxml2:2="
RDEPEND="${DEPEND}"

PATCHES=(
	# Fix pointer-related bug detected by a QA notice
	"${FILESDIR}"/${PN}-pointer_fix.patch
	# Don't strip symbols from binary (bug #152266)
	"${FILESDIR}"/${P}-makefile.patch
	# Fix GCC 10 -fno-common change
	"${FILESDIR}"/${P}-gcc10-no-common.patch
	# bug #923170
	"${FILESDIR}"/${P}-c99.patch
)

src_prepare() {
	default

	# Clang 16, bug #900539
	eautoreconf
}

src_configure() {
	tc-export CC
	# bug #944764
	append-cflags -std=gnu17
	econf --disable-pdf
}

src_compile() {
	default

	cd doc || die
	"${S}"/src/xml2doc -oM manpage.xml xml2doc.1 || die
}

src_install() {
	dobin src/xml2doc

	einstalldocs
	docinto examples
	dodoc examples/*.{xml,png}

	doman doc/xml2doc.1
}
