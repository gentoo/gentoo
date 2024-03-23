# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib toolchain-funcs

DESCRIPTION="Arithmetic and logic operations over arbitrary-precision integers"
HOMEPAGE="https://github.com/ocaml/Zarith"
SRC_URI="https://github.com/ocaml/Zarith/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc x86"
IUSE="doc +ocamlopt"
RESTRICT="!ocamlopt? ( test )"

RDEPEND="
	>=dev-lang/ocaml-4.05:=[ocamlopt=]
	dev-libs/gmp:0=
"
DEPEND="${RDEPEND} dev-lang/perl"

DOCS=( README.md Changes )

S="${WORKDIR}/Zarith-release-${PV}"

src_configure() {
	tc-export CC AR
	./configure \
		-ocamllibdir /usr/$(get_libdir)/ocaml -gmp || die
	sed -i \
		-e 's|$(INSTALLDIR)|$(DESTDIR)$(INSTALLDIR)|g' \
		project.mak || die
}

src_compile() {
	emake -j 1 HASOCAMLOPT=$(usex ocamlopt yes no) HASDYNLINK=$(usex ocamlopt yes no) all
	use doc && emake doc
}

src_test() {
	emake HASOCAMLOPT=yes HASDYNLINK=yes tests
}

src_install() {
	findlib_src_preinst

	emake \
		HASOCAMLOPT=$(usex ocamlopt yes no) \
		HASDYNLINK=$(usex ocamlopt yes no) \
		DESTDIR="${ED}" \
		install

	dosym zarith/libzarith.a /usr/$(get_libdir)/ocaml/libzarith.a

	use doc && HTML_DOCS=( html/* )
	einstalldocs
}
