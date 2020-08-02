# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://github.com/ocaml/dune"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 x86"
IUSE="test"

DEPEND="dev-lang/ocaml"
RDEPEND="${DEPEND}
	!dev-ml/jbuilder"
BDEPEND=""

RESTRICT="test"

src_configure() {
	ocaml configure.ml --libdir "${EPREFIX}/usr/$(get_libdir)/ocaml" || die
}

src_install() {
	default
	mv "${D}"/usr/doc "${D}"/usr/share/doc/${PF}
	mv "${D}"/usr/man "${D}"/usr/share/man
}
