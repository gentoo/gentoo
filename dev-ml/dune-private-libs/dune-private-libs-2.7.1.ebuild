# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> dune-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+ocamlopt test"

DEPEND="
	dev-ml/csexp:=
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? (
		dev-ml/ppx_expect
		)"
S=${WORKDIR}/dune-${PV}

src_prepare() {
	default
	# remove tests that run git
	rm -f \
		test/blackbox-tests/test-cases/dune-project-meta/main.t/run.t \
		test/blackbox-tests/test-cases/meta-template-version-bug.t \
		test/blackbox-tests/test-cases/subst.t/run.t \
		test/expect-tests/vcs_tests.ml \
		|| die
}

src_configure(){
	:
}
