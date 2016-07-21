# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils

DESCRIPTION="Functional programming language for reactive system design (digital logic, hard-real-time software)"
HOMEPAGE="http://www.funhdl.org/wiki/doku.php?id=confluence"
SRC_URI="http://www.funhdl.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ia64 ~ppc ~sparc x86"
IUSE="+ocamlopt"

# min version so we are sure we always have ocamlopt in IUSE
RDEPEND=">=dev-lang/ocaml-3.10[ocamlopt?]"
DEPEND="${RDEPEND}
	sys-apps/sed"

src_prepare() {
	# Install non binary stuff in share...
	sed -i -e "s:lib/confluence:share/confluence:" Makefile || die "failed to sed the makefile"
	sed -i -e "s:lib/confluence:share/confluence:" src/cfeval/cf.ml || die "failed to sed ml files"
	sed -i -e "s:lib/confluence:share/confluence:" src/cfeval/cfParserUtil.ml || die "failed to sed ml files"
	if ! use ocamlopt; then
		sed -i -e "s:cmxa:cma:" src/Makefile || die "failed to disable ocamlopt	support"
		sed -i -e "s:cmx:cmo:" src/Makefile || die "failed to disable ocamlopt	support"
	fi
}

src_compile() {
	if use ocamlopt; then
		emake -j1 PREFIX="${D}/usr" OCAMLLIB=`ocamlc -where` || die "failed to build"
	else
		emake -j1 OCAMLOPT="ocamlc" OCAMLC="ocamlc" PREFIX="${D}/usr" OCAMLLIB=`ocamlc -where` || die "failed to build"
	fi
}

src_install() {
	emake -j1 PREFIX="${D}/usr" OCAMLLIB=`ocamlc -where` install || die "install failed"
	echo "CF_LIB=/usr/share/confluence" > "${T}/99${PN}"
	doenvd "${T}/99${PN}"
	dodoc NEWS || die
}
