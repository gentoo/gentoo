# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit multilib findlib eutils

MY_P=${P%_p*}
DESCRIPTION="A preprocessor-pretty-printer of ocaml"
HOMEPAGE="http://camlp5.gforge.inria.fr/"
SRC_URI="http://camlp5.gforge.inria.fr/distrib/src/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="alpha amd64 ppc x86 ~x86-fbsd"
IUSE="doc +ocamlopt"

DEPEND=">=dev-lang/ocaml-3.10:=[ocamlopt?]"
RDEPEND="${DEPEND}"

PATCHLEVEL=${PV#*_p}
PATCHLIST=""

if [ "${PATCHLEVEL}" != "${PV}" ] ; then
	for (( i=1; i<=PATCHLEVEL; i++ )) ; do
		SRC_URI="${SRC_URI}
			http://pauillac.inria.fr/~ddr/camlp5/distrib/src/patch-${PV%_p*}-${i} -> ${MY_P}-patch-${i}.patch"
		PATCHLIST="${PATCHLIST} ${MY_P}-patch-${i}.patch"
	done
fi

S=${WORKDIR}/${MY_P}

src_prepare() {
	for i in ${PATCHLIST} ; do
		epatch "${DISTDIR}/${i}"
	done
}

src_configure() {
	./configure \
		--strict \
		-prefix /usr \
	    -bindir /usr/bin \
		-libdir /usr/$(get_libdir)/ocaml \
		-mandir /usr/share/man || die "configure failed"
}

src_compile(){
	emake out
	if use ocamlopt; then
		emake  opt
		emake  opt.opt
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	# findlib support
	insinto "$(ocamlfind printconf destdir)/${PN}"
	doins etc/META

	use doc && dohtml -r doc/*

	dodoc CHANGES DEVEL ICHANGES README UPGRADING MODE
}
