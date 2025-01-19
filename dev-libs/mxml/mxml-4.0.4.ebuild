# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="A small XML parsing library that you can use to read XML data files or strings"
HOMEPAGE="
	https://github.com/michaelrsweet/mxml
	https://www.msweet.org/mxml/
"
SRC_URI="https://github.com/michaelrsweet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Mini-XML"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="static-libs test threads"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Don't hardcode FORTIFY_SOURCE
	sed -e 's/-D_FORTIFY_SOURCE=3//g' -i configure || die
	sed -e 's/-D_FORTIFY_SOURCE=3//g' -i configure.ac || die

	# Don't run always tests
	# Enable verbose compiling
	sed -e '/ALLTARGETS/s/testmxml//g' -e '/.SILENT:/d' -i Makefile.in || die
	eautoconf
}

src_configure() {
	local myeconfargs=(
		AR="$(tc-getAR)"
		$(use_enable static-libs static)
		$(use_enable threads)
		--with-docdir=/usr/share/doc/"${PF}"
		--with-dsoflags="${LDFLAGS}"
		--with-ldflags="${LDFLAGS}"

	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	use test && emake testmxml
}

src_test() {
	emake test
}

src_install() {
	emake DSTROOT="${ED}" install
}
