# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Cooperative light-weight thread library for OCaml"
SRC_URI="https://github.com/ocsigen/lwt/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="http://ocsigen.org/lwt"

IUSE="+camlp4 +libev"

DEPEND="
	>=dev-lang/ocaml-4.02:=
	dev-ml/result:=
	dev-ml/ocaml-migrate-parsetree:=
	dev-ml/ppx_tools_versioned:=
	libev? ( dev-libs/libev )
	camlp4? ( dev-ml/camlp4:= )"

RDEPEND="${DEPEND}
	!<www-servers/ocsigen-1.1"
DEPEND="${DEPEND}
	dev-ml/cppo
	dev-ml/findlib
	dev-ml/jbuilder
	dev-ml/opam"

SLOT="0/${PV}"
LICENSE="LGPL-2.1-with-linking-exception"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"

src_configure() {
	ocaml src/util/configure.ml \
		-use-libev $(usex libev true false) \
		-use-camlp4 $(usex camlp4 true false) \
		|| die
}

src_compile() {
	jbuilder  build -p lwt || die
	ocaml src/util/install_filter.ml || die
}

src_test() {
	jbuilder runtest -p lwt || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		--mandir="${ED}/usr/share/man" \
		${PN}.install || die
}
