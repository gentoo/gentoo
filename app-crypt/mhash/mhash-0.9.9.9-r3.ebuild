# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Library providing a uniform interface to a large number of hash algorithms"
HOMEPAGE="https://mhash.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/mhash/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="static-libs"

BDEPEND="dev-lang/perl" # pod2html

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.9-fix-mem-leak.patch
	"${FILESDIR}"/${PN}-0.9.9-fix-snefru-segfault.patch
	"${FILESDIR}"/${PN}-0.9.9-fix-whirlpool-segfault.patch
	"${FILESDIR}"/${PN}-0.9.9-autotools-namespace-stomping.patch
	"${FILESDIR}"/${P}-remove_premature_free.patch
	"${FILESDIR}"/${P}-force64bit-tiger.patch
	"${FILESDIR}"/${P}-align.patch
	"${FILESDIR}"/${P}-alignment.patch
	"${FILESDIR}"/${P}-no-malloc-check.patch
	"${FILESDIR}"/${P}-hmac-uaf-test.patch
	"${FILESDIR}"/${P}-cast-temp-64bit.patch
)

DOCS=( doc/example.c doc/skid2-authentication )

HTML_DOCS=( doc/mhash.html )

src_prepare() {
	default

	sed -i \
		-e 's/--netscape//' \
		"${S}"/doc/Makefile.in || die

	sed \
		-e "s:@VERSION@:${PV}:" \
		"${FILESDIR}"/${PN}.pc > ${PN}.pc || die

	# Refresh bundled libtool (ltmain.sh)
	# (elibtoolize is not sufficient)
	# bug #668666
	eautoreconf
}

src_configure() {
	# bug #943960
	append-cflags -std=gnu17

	econf $(use_enable static-libs static)
}

src_compile() {
	default

	emake -C doc mhash.html
}

src_install() {
	default
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
	find "${ED}" -name '*.la' -delete || die
}
