# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Class library (C++) for numbers"
HOMEPAGE="https://www.ginac.de/CLN/"
SRC_URI="https://www.ginac.de/CLN/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="dev-libs/gmp:0="
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

pkg_setup() {
	use sparc && append-cppflags -DNO_ASM
	use hppa && append-cppflags -DNO_ASM
	use arm && append-cppflags -DNO_ASM
}

src_prepare() {
	default
	# avoid building examples
	# do it in Makefile.in to avoid time consuming eautoreconf
	sed -i \
		-e '/^SUBDIRS.*=/s/examples doc benchmarks/doc/' \
		Makefile.in || die
}

src_configure() {
	econf --disable-static
}

src_compile() {
	default
	if use doc; then
		pushd doc > /dev/null
		export VARTEXFONTS="${T}/fonts"
		emake html pdf
		DOCS=( doc/cln.pdf )
		HTML_DOCS=( doc/cln.html )
	fi
}

src_install() {
	default
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc examples/*.cc
	fi

	find "${ED}" -name '*.la' -delete || die
}
