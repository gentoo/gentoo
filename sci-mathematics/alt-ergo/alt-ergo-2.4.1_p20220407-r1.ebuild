# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=4e082218efe6e0e2315331580bbd08306c1f8a2d

inherit dune

DESCRIPTION="Automatic theorem prover"
HOMEPAGE="https://alt-ergo.ocamlpro.com"
SRC_URI="https://github.com/OCamlPro/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="CeCILL-C"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="examples +ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.09.0:=[ocamlopt=]
	>=sci-mathematics/psmt2-frontend-0.4.0:=

	>=dev-ml/cmdliner-1.1.0:=
	>=dev-ml/menhir-20181006:=
	>=dev-ml/ocplib-simplex-0.4:=
	dev-ml/camlzip:=
	dev-ml/num:=
	dev-ml/seq:=
	dev-ml/stdlib-shims:=
	dev-ml/zarith:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-ml/dune-configurator"
REQUIRED_USE="ocamlopt"

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
