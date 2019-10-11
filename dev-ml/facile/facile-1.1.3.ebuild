# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="OCaml constraint programming library on integer & integer set finite domains"
HOMEPAGE="http://opti.recherche.enac.fr/"
SRC_URI="http://opti.recherche.enac.fr/facile/distrib/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"

KEYWORDS="alpha amd64 arm64 hppa ia64 ppc ppc64 ~sparc x86"
IUSE="+ocamlopt"

RDEPEND=">=dev-lang/ocaml-4:=[ocamlopt?]"
DEPEND="${RDEPEND}
	sys-apps/sed
"

DOCS=( README )

PATCHES=( "${FILESDIR}/${PN}"-1.1-make.patch ) # Fix building on FreeBSD

src_prepare() {
	default

	# Disable building native code objects if we dont have/want ocamlopt
	if ! use ocamlopt; then
		sed -i -e 's/\.opt//' src/Makefile || die "failed to change native code compiler to bytecode ones"
		sed -i -e 's/ facile\.cmxa//' src/Makefile || die "failed to remove native code objects"
		sed -i -e 's/\.opt/.out/g' \
			-e 's: src/facile\.cmxa::'\
			-e 's: src/facile\.a::'\
			-e 's:^.*facile\.cmxa::'\
			-e 's:^.*facile\.a::' Makefile || die "failed to remove native code objects"
	fi
}

src_configure(){
	# This is a custom configure script and it does not support standard options
	./configure --faciledir "${D}"$(ocamlc -where)/facile/ || die
}

src_test() {
	emake check
}

src_install(){
	dodir $(ocamlc -where)
	emake install
	einstalldocs
}
