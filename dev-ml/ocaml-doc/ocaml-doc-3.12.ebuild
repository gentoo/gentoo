# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/ocaml-doc/ocaml-doc-3.12.ebuild,v 1.3 2012/06/10 04:53:22 jdhore Exp $

DESCRIPTION="Ocaml reference manual (html)"
HOMEPAGE="http://caml.inria.fr/pub/docs/manual-ocaml/"
SRC_URI="http://caml.inria.fr/pub/distrib/ocaml-${PV}/ocaml-${PV}-refman.html.tar.gz"
LICENSE="GPL-2"

KEYWORDS="amd64 ~ppc x86"

SLOT="0"
IUSE=""

S=${WORKDIR}/htmlman

src_install() {
	dohtml -r *
}

pkg_postinst() {
	elog "This manual is available online at http://caml.inria.fr/pub/docs/manual-ocaml/"
}
