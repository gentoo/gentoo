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
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
IUSE="+ocamlopt doc +deriving +ppx +react +xml X"

RDEPEND="
	>=dev-lang/ocaml-3.12:=[ocamlopt?,X(+)?]
	>=dev-ml/lwt-2.4.4:=[camlp4(+)]
	react? ( dev-ml/react:=  dev-ml/reactiveData:= )
	xml? ( >=dev-ml/tyxml-4:= )
	ppx? ( dev-ml/ppx_tools:= dev-ml/ppx_deriving:= dev-ml/ppx_driver:= )
	dev-ml/cmdliner:=
	dev-ml/menhir:=
	dev-ml/ocaml-base64:=
	dev-ml/camlp4:=
	dev-ml/cppo:=
	dev-ml/uchar:=
	dev-ml/ocamlbuild:=
	dev-ml/yojson:=
	dev-ml/ocaml-migrate-parsetree:=
	deriving? ( >=dev-ml/deriving-0.6:= )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/ppx.patch"
	has_version '>=dev-lang/ocaml-4.05_rc' && epatch "${FILESDIR}/ocaml405.patch"
}

src_configure() {
	printf "\n\n" >> Makefile.conf
	use ocamlopt || echo "BEST := byte" >> Makefile.conf
	use ocamlopt || echo "NATDYNLINK := NO" >> Makefile.conf
	use deriving || echo "WITH_DERIVING := NO" >> Makefile.conf
	use X || echo "WITH_GRAPHICS := NO" >> Makefile.conf
	use react || echo "WITH_REACT := NO" >> Makefile.conf
	use ppx || echo "WITH_PPX := NO" >> Makefile.conf
	use ppx || echo "WITH_PPX_DERIVING := NO" >> Makefile.conf
	use ppx || echo "WITH_PPX_DRIVER := NO" >> Makefile.conf
	echo "WITH_ASYNC := NO" >> Makefile.conf
}

src_compile() {
	emake -j1
	use doc && emake doc
}

src_install() {
	findlib_src_preinst
	emake BINDIR="${ED}/usr/bin/" install
	dodoc CHANGES README.md
	use doc && dohtml -r doc/api/html/
}
