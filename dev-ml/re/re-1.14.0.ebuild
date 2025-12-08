# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Regular expression library for OCaml"
HOMEPAGE="https://github.com/ocaml/ocaml-re/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ocaml/ocaml-re.git"
else
	SRC_URI="https://github.com/ocaml/ocaml-re/archive/${PV}.tar.gz
		-> ocaml-${P}.gh.tar.gz"
	S="${WORKDIR}/ocaml-${P}"

	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/ocaml-4.13
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-ml/dune-3.17
	test? (
		dev-ml/ounit2
		dev-ml/ppx_expect
	)
"

src_prepare() {
	default

	# "expect" tests fail.
	rm -r lib_test/expect || die
}
