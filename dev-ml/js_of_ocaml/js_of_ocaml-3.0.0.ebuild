# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib eutils

DESCRIPTION="A compiler from OCaml bytecode to javascript"
HOMEPAGE="http://ocsigen.org/js_of_ocaml/"

if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/ocsigen/js_of_ocaml"
	KEYWORDS=""
else
	SRC_URI="https://github.com/ocsigen/js_of_ocaml/archive/${PV}.tar.gz -> ${P}.tar.gz"
	# Breaks dev-ml/eliom dev-ml/async_js dev-ml/ocsigen-toolkit
	KEYWORDS=""
	#KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
IUSE="+ocamlopt +camlp4 +lwt doc +deriving +ppx +xml test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/ocaml-3.12:=[ocamlopt?]

	camlp4? ( dev-ml/camlp4:= )

	dev-ml/cmdliner:=
	dev-ml/cppo:=

	lwt? ( >=dev-ml/lwt-2.4.4:= )

	dev-ml/ocamlbuild:=

	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/ppx_tools_versioned:=
	dev-ml/uchar:=

	ppx? ( dev-ml/ppx_tools:= dev-ml/ppx_deriving:= )

	xml? ( >=dev-ml/tyxml-4:= dev-ml/reactiveData:= )
"
DEPEND="${RDEPEND}
	dev-ml/jbuilder
	dev-ml/opam
	test? ( dev-util/patdiff )
"
REQUIRED_USE="xml? ( ppx )"

src_compile() {
	emake
	use doc && emake doc
}

oinstall() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		--mandir="${ED}/usr/share/man" \
		${1}.install || die
}

src_install() {
	use camlp4 && oinstall js_of_ocaml-camlp4
	oinstall js_of_ocaml-compiler
	use lwt && oinstall js_of_ocaml-lwt
	oinstall js_of_ocaml-ocamlbuild
	oinstall js_of_ocaml
	use ppx && oinstall js_of_ocaml-ppx
	use ppx && oinstall js_of_ocaml-toplevel
	use xml && oinstall js_of_ocaml-tyxml
}
