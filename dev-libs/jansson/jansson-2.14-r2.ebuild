# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C library for encoding, decoding and manipulating JSON data"
HOMEPAGE="https://www.digip.org/jansson/"
SRC_URI="https://github.com/akheron/jansson/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0/4"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="doc static-libs"

BDEPEND="
	dev-build/autoconf-archive
	doc? ( dev-python/sphinx )
"

PATCHES=(
	"${FILESDIR}/${P}-default-symver-test.patch"
	"${FILESDIR}/${P}-test-symbols.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	default

	if use doc ; then
		emake html
		HTML_DOCS=( doc/_build/html/. )
	fi
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
