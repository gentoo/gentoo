# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Compatibility module for OCaml standard library"
HOMEPAGE="https://github.com/thierry-martinez/stdcompat"
SRC_URI="https://github.com/thierry-martinez/stdcompat/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
SLOT="0/${PV}"

DEPEND="dev-lang/ocaml:=[ocamlopt]
	dev-ml/result:=[ocamlopt]
	dev-ml/uchar:=[ocamlopt]"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-ml/dune
	dev-ml/findlib[ocamlopt]"

# Do not complain about CFLAGS etc since ml projects do not use them.
QA_FLAGS_IGNORED='.*'

src_configure () {
	econf --libdir="${EPREFIX}"/usr/$(get_libdir)/ocaml
}
