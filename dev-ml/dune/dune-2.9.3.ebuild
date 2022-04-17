# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/ocaml-4.08:=
"
DEPEND="
	${RDEPEND}
	dev-ml/findlib
	test? (
		dev-ml/core_bench
		dev-ml/ppx_bench
		dev-ml/ppx_expect
	)
"

QA_FLAGS_IGNORED="usr/bin/dune"

src_configure() {
	:
}

src_compile() {
	ocaml bootstrap.ml -j $(makeopts_jobs) || die
	./dune.exe build -p "${PN}" --profile dune-bootstrap -j $(makeopts_jobs) \
		--display short || die
}

src_install() {
	default
	mv "${ED}"/usr/doc "${ED}"/usr/share/doc/${PF} || die
	mv "${ED}"/usr/man "${ED}"/usr/share/man || die
}
