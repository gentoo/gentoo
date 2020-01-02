# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit multilib findlib eutils

MY_P=${P%_p*}
echo $MY_P
DESCRIPTION="A preprocessor-pretty-printer of ocaml"
HOMEPAGE="https://camlp5.github.io/"
SRC_URI="https://github.com/camlp5/camlp5/archive/rel$(ver_rs 1- '').tar.gz -> ${P}.tar.gz"
echo $SRC_URI
S="${WORKDIR}/${PN}-rel$(ver_rs 1- '')"
echo $S
LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="doc +ocamlopt"

DEPEND="
	>=dev-lang/ocaml-3.10:=[ocamlopt?]
	<=dev-lang/ocaml-4.6.0
"
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

src_prepare() {

	for i in ${PATCHLIST} ; do
		epatch "${DISTDIR}/${i}"
	done
	eapply_user
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

	dodoc CHANGES DEVEL ICHANGES README.md UPGRADING MODE
}
