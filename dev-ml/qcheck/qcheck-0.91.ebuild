# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="QuickCheck inspired property-based testing for OCaml"
HOMEPAGE="https://github.com/c-cube/qcheck"
SRC_URI="https://github.com/c-cube/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/alcotest:=[ocamlopt?]
	dev-ml/ounit2:=[ocamlopt?]
	>=dev-ml/ppxlib-0.36.0:=[ocamlopt?]
"
DEPEND="${RDEPEND}"

src_install() {
	# "ppx_deriving_qcheck" does not install but only "ppx_pbt" depends on it
	local i
	for i in qcheck qcheck-alcotest qcheck-core qcheck-ounit ; do
		dune_src_install ${i}
	done

	einstalldocs
}

src_test() {
	# Introduced in alcotest 1.8.0, some tests rely on pretty-printed
	# alcotest output
	local -x ALCOTEST_COLUMNS=80
	emake test
}
