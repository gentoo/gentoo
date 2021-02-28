# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="An equivalent of the C preprocessor for OCaml programs"
HOMEPAGE="http://mjambon.com/cppo.html https://github.com/mjambon/cppo/"
SRC_URI="https://github.com/mjambon/cppo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/${PV}"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"

IUSE="examples +ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-3.12:=[ocamlopt?]
	dev-ml/ocamlbuild:=[ocamlopt?]"
DEPEND="${RDEPEND}"

src_compile() {
	use ocamlopt || sed -e 's/ocamlbuild_cppo.cmx/ocamlbuild_cppo.cmo/' -i Makefile
	emake BEST="$(usex ocamlopt '.native' '.byte')" $(usex ocamlopt opt all) ocamlbuild
}

src_install() {
	findlib_src_preinst

	mkdir -p "${ED}"/usr/bin
	emake PREFIX="${ED}"/usr BEST="$(usex ocamlopt '.native' '.byte')" install
	dodoc README.md Changes

	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
