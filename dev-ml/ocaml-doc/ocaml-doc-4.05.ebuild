# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Ocaml reference manual (html)"
HOMEPAGE="https://caml.inria.fr/pub/docs/manual-ocaml/"
SRC_URI="https://caml.inria.fr/pub/distrib/ocaml-${PV}/ocaml-${PV}-refman-html.tar.gz"
S="${WORKDIR}"/htmlman

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

src_install() {
	docinto html
	dodoc -r *
}

pkg_postinst() {
	elog "This manual is available online at https://caml.inria.fr/pub/docs/manual-ocaml/"
}
