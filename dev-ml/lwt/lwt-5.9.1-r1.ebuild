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
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libev
	dev-ml/luv:=[ocamlopt?]
	dev-ml/mmap:=[ocamlopt?]
	dev-ml/ocplib-endian:=[ocamlopt?]
	dev-ml/ppx_let:=[ocamlopt?]
	dev-ml/ppxlib:=[ocamlopt?]
	dev-ml/react:=
	dev-ml/result:=[ocamlopt?]
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-ml/cppo
	dev-ml/findlib
	test? ( dev-ml/ppx_here )
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
	if has_version ">=dev-ml/ppxlib-0.36.0"; then
		eapply "${FILESDIR}"/${P}-ppxlib.patch
	fi
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
