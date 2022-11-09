# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Automatic theorem prover"
HOMEPAGE="https://alt-ergo.ocamlpro.com"
SRC_URI="https://github.com/OCamlPro/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CeCILL-C"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="examples gui +ocamlopt"
REQUIRED_USE="ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.09.0:=[ocamlopt=]
	>=sci-mathematics/psmt2-frontend-0.4.0:=

	>=dev-ml/cmdliner-1.1.0:=
	>=dev-ml/menhir-20181006:=
	>=dev-ml/ocplib-simplex-0.4:=
	dev-ml/camlzip:=
	dev-ml/num:=
	dev-ml/stdlib-shims:=
	dev-ml/zarith:=
	gui? (
		dev-ml/lablgtk:3
		dev-ml/lablgtk-sourceview:3
	)
"
DEPEND="${RDEPEND}"
BDEPEND="dev-ml/dune-configurator"

src_prepare() {
	default

	if ! use gui ; then
		rm -r src/bin/gui || die
	fi
}

src_configure() {
	sh ./configure --prefix /usr --libdir=/usr/$(get_libdir) || die
}

src_install() {
	dune-install alt-ergo-lib alt-ergo-parsers alt-ergo

	use gui && dune-install altgr-ergo
	use examples && dodoc -r examples
}
