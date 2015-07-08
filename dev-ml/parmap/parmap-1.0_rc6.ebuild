# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/parmap/parmap-1.0_rc6.ebuild,v 1.2 2015/07/08 05:49:29 patrick Exp $

EAPI=5

inherit multilib

MY_PV="${PV/_/-}"
DESCRIPTION="Library allowing to exploit multicore architectures for OCaml programs with minimal modifications"
HOMEPAGE="http://www.dicosmo.org/code/parmap/"
SRC_URI="https://github.com/rdicosmo/parmap/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND=">=dev-lang/ocaml-3.12:=[ocamlopt?]"
DEPEND="${RDEPEND}
	dev-ml/findlib"
S="${WORKDIR}/${PN}-${MY_PV}"

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
	dodoc AUTHORS ChangeLog README
}
