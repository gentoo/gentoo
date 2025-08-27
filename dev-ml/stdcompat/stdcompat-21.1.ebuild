# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Compatibility module for OCaml standard library"
HOMEPAGE="https://github.com/ocamllibs/stdcompat"
SRC_URI="https://github.com/ocamllibs/stdcompat/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

DEPEND=">dev-lang/ocaml-4.11:=[ocamlopt]
	dev-ml/result:=[ocamlopt]
	dev-ml/uchar:=[ocamlopt]"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-ml/dune
	dev-ml/findlib[ocamlopt]"

# Do not complain about CFLAGS etc since ml projects do not use them.
QA_FLAGS_IGNORED='.*'

src_prepare() {
	default
	eautoreconf
}

src_configure () {
	econf --libdir="${EPREFIX}"/usr/$(get_libdir)/ocaml
}
