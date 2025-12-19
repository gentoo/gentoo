# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib vcs-clean

DESCRIPTION="Standard library extensions for O'Caml"
HOMEPAGE="https://github.com/ygrek/ocaml-extlib/"
SRC_URI="https://github.com/ygrek/ocaml-extlib/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/ocaml-${P}

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="doc +ocamlopt"

BDEPEND="dev-ml/cppo"

src_prepare() {
	default

	egit_clean
}

src_compile() {
	cd "${S}"/src || die

	emake -j1 all

	use ocamlopt && emake opt cmxs
	use doc && emake doc
}

src_test() {
	emake -j1 test
}

src_install() {
	findlib_src_install

	dodoc README.md

	use doc && dodoc -r src/doc/
}
