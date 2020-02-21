# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Compatibility package for the standard OCaml iterator type"
HOMEPAGE="https://github.com/c-cube/seq"
SRC_URI="https://github.com/c-cube/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-ml/findlib
	dev-ml/ocamlbuild
	dev-lang/ocaml[ocamlopt]"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	sed -i \
		-e "s:@LIBDIR@:/usr/$(get_libdir)/ocaml:" \
		Makefile \
		|| die
}

src_install() {
	dodir /usr/$(get_libdir)/ocaml
	default
}
