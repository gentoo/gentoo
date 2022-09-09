# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Simple library for creating daemon processes in C"
HOMEPAGE="http://0pointer.de/lennart/projects/libdaemon/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/5"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="doc examples"

BDEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${PV}-man-page-typo-fix.patch
)

src_prepare() {
	default

	# Refresh bundled libtool (ltmain.sh)
	# (elibtoolize is insufficient)
	# bug #668404
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--localstatedir="${EPREFIX}"/var
		--disable-examples
		--disable-lynx
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake

	if use doc; then
		einfo "Building documentation"
		emake doxygen

		HTML_DOCS=( doc/README.html doc/style.css doc/reference/html/. )
	fi
}

src_install() {
	default

	use doc && doman doc/reference/man/man3/*.h.3

	find "${ED}" -name '*.la' -delete || die

	if use examples; then
		docinto examples
		dodoc examples/testd.c
	fi
}
