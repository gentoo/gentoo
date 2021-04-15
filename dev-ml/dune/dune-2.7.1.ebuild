# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="test"

DEPEND=">=dev-lang/ocaml-4.08:="
RDEPEND="${DEPEND}
	!dev-ml/jbuilder"

RESTRICT="test"

src_configure() {
	:
}

src_compile() {
	ocaml bootstrap.ml || die
	./dune.exe build -p "${PN}" --profile dune-bootstrap -j $(makeopts_jobs) || die
}

src_install() {
	default
	mv "${ED}"/usr/doc "${ED}"/usr/share/doc/${PF} || die
	mv "${ED}"/usr/man "${ED}"/usr/share/man || die
}
