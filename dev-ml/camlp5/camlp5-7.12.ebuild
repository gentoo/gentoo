# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib vcs-clean

DESCRIPTION="A preprocessor-pretty-printer of ocaml"
HOMEPAGE="https://camlp5.github.io/"
SRC_URI="https://github.com/camlp5/camlp5/archive/rel$(ver_rs 1- '').tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-rel$(ver_rs 1- '')"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="doc +ocamlopt"

DEPEND="
	<dev-lang/ocaml-4.11.2:=[ocamlopt?]
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-7.12-destdir.patch" )

camlp5_hack_ocaml_support() {
	ln -s "${1}"    "ocaml_stuff/${2}"              || die
	ln -s "${1}.ml" "ocaml_src/lib/versdep/${2}.ml" || die
}

src_prepare() {
	egit_clean
	default
	camlp5_hack_ocaml_support 4.11.0 4.11.1
}

src_configure() {
	./configure \
		--strict \
		-prefix /usr \
		-bindir /usr/bin \
		-libdir /usr/$(get_libdir)/ocaml \
		-mandir /usr/share/man || die "configure failed"
}

src_compile() {
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

	dodoc -r doc/*
	dodoc CHANGES DEVEL ICHANGES README.md UPGRADING MODE
}
