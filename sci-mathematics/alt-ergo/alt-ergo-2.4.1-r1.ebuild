# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Automatic theorem prover"
HOMEPAGE="https://alt-ergo.ocamlpro.com"
SRC_URI="https://github.com/OCamlPro/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CeCILL-C"
SLOT="0/${PV}"
KEYWORDS="amd64"
IUSE="examples +ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.09.0:=[ocamlopt=]
	>=sci-mathematics/psmt2-frontend-0.4.0:=

	>=dev-ml/menhir-20181006:=
	>=dev-ml/ocplib-simplex-0.4:=
	dev-ml/camlzip:=
	dev-ml/cmdliner:=
	dev-ml/num:=
	dev-ml/seq:=
	dev-ml/stdlib-shims:=
	dev-ml/zarith:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-ml/dune-configurator"

src_prepare() {
	default

	# Remove the GTK2 GUI frontend because GTK2 in Gentoo is deprecated
	rm -r src/bin/gui || die
}

src_configure() {
	sh ./configure --prefix /usr --libdir=/usr/$(get_libdir) || die
}

src_install() {
	dune-install alt-ergo-lib alt-ergo-parsers alt-ergo

	use examples && dodoc -r examples
}
