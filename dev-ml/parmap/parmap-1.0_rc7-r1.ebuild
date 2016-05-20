# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib

MY_PV="${PV/_/-}-fix-for4.03+3"
DESCRIPTION="Library allowing to exploit multicore architectures for OCaml programs with minimal modifications"
HOMEPAGE="http://www.dicosmo.org/code/parmap/"
SRC_URI="https://github.com/rdicosmo/parmap/archive/${MY_PV}.tar.gz -> ${P}-ocaml-4.03.tar.gz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND=">=dev-lang/ocaml-4.03:=[ocamlopt?]"
DEPEND="${RDEPEND}
	dev-ml/findlib
	dev-ml/ocamlbuild
	dev-ml/ocaml-autoconf"
S="${WORKDIR}/${PN}-${MY_PV/+/-}"

src_test() {
	mkdir "${WORKDIR}/tmpinstall" || die
	emake \
		OCAMLLIBDIR="ocaml" \
		DESTDIR="${WORKDIR}/tmpinstall" \
		install
	export OCAMLPATH="${WORKDIR}/tmpinstall/ocaml"
	emake tests
	cd _build/tests || die
	for i in $(find . -type f -executable) ; do
		${i} || die
	done
}

src_install() {
	emake \
		OCAMLLIBDIR="$(get_libdir)/ocaml" \
		MANDIR="${ED}/usr/share/man/man3o" \
		DESTDIR="${ED}/usr" \
		install
	dodoc AUTHORS Changelog README
}
