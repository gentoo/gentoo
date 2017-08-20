# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib eutils

DESCRIPTION="Dereference URIs into communication channels for Async or Lwt"
HOMEPAGE="https://github.com/mirage/ocaml-conduit"
SRC_URI="https://github.com/mirage/ocaml-conduit/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-lang/ocaml:=
	dev-ml/sexplib:=
	dev-ml/stringext:=
	dev-ml/ocaml-uri:=
	dev-ml/logs:=
	dev-ml/ocaml-cstruct:=
	dev-ml/ocaml-ipaddr:=

	>=dev-ml/lwt-3:=
	dev-ml/async:=
	dev-ml/ocaml-dns:=
	dev-ml/ocaml-ssl:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/findlib
	dev-ml/ocamlbuild
	dev-ml/ppx_driver
	dev-ml/ppx_optcomp
	dev-ml/ppx_sexp_conv
"

DOCS=( TODO.md README.md CHANGES )

src_install() {
	findlib_src_preinst
	default
}
