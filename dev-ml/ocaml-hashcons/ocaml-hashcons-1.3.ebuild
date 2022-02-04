# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools findlib

DESCRIPTION="OCaml hash-consing library"
HOMEPAGE="https://github.com/backtracking/ocaml-hashcons"
SRC_URI="https://github.com/backtracking/ocaml-hashcons/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="dev-lang/ocaml:=[ocamlopt?]"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	eautoreconf

	sed -i -e 's/$(OCAMLFIND) remove/#/' Makefile.in || die
}

src_compile() {
	if use ocamlopt; then
		emake opt byte
	else
		emake byte
	fi
}

src_install() {
	local destdir=$(ocamlfind printconf destdir || die)
	dodir ${destdir}/hashcons

	emake \
		DESTDIR="-destdir ${D}"/${destdir}/ \
		$(usex ocamlopt install-opt install-byte)

	dodoc README.md CHANGES
}
