# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit opam

DESCRIPTION="A composable build system for OCaml"
HOMEPAGE="https://dune.build"
SRC_URI="https://github.com/ocaml/dune/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="test"

DEPEND="test? ( dev-ml/menhir )"
RDEPEND="${DEPEND}"

OPAMSWITCH="system"
OPAMROOT="${D}"

src_configure() { :; }

src_compile() {
	emake release LIBDIR="${EPREFIX}/usr/$(get_libdir)/ocaml"
}
