# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="QuickCheck inspired property-based testing for OCaml"
HOMEPAGE="https://github.com/c-cube/qcheck"
SRC_URI="https://github.com/c-cube/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"
RESTRICT="test"  # tests fail

RDEPEND="
	dev-ml/alcotest:=
	dev-ml/ounit2:=
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
	emake test
}
