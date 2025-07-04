# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Cooperative light-weight thread library for OCaml"
HOMEPAGE="http://ocsigen.org/lwt"
SRC_URI="https://github.com/ocsigen/lwt/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ocamlopt"

DEPEND="
	dev-libs/libev
	dev-ml/luv:=
	dev-ml/mmap:=
	dev-ml/ocplib-endian:=
	dev-ml/ppx_let:=
	dev-ml/ppxlib:=
	dev-ml/react:=
	dev-ml/result:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-ml/cppo
	dev-ml/findlib
"

# "domainslib" is unpackaged.
OCAML_SUBPACKAGES=(
	lwt
	lwt_ppx
	lwt_react
	lwt_retry
)

src_prepare() {
	sed -i "s| seq||" "${S}"/src/core/dune || die

	default
}

src_compile() {
	dune-compile ${OCAML_SUBPACKAGES[@]}
}

src_test() {
	dune-test ${OCAML_SUBPACKAGES[@]}
}

src_install() {
	dune-install ${OCAML_SUBPACKAGES[@]}

	einstalldocs
}
