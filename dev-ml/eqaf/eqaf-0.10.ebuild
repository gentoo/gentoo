# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Constant time equal function to avoid timing attacks in OCaml"
HOMEPAGE="https://github.com/mirage/eqaf"
SRC_URI="https://github.com/mirage/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DOCS=( README.md CHANGES.md )

RDEPEND="
	dev-ml/cstruct:=[ocamlopt?]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-ml/ocaml-base64
		dev-ml/alcotest
		dev-ml/fmt
	)
"

src_prepare() {
	default
	# requires unpackaged crowbar
	rm -rf fuzz || die
}

src_test() {
	if has_version -b ">=dev-lang/ocaml-5.5"; then
		# test/test_branch.ml fails to build with OCaml 5.5
		# https://github.com/mirage/eqaf/issues/50
		edune exec --display=short -j $(get_makeopts_jobs) test/test.exe
	else
		dune_src_test
	fi
}
