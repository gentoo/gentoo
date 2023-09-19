# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="A preprocessor-pretty-printer of ocaml"
HOMEPAGE="https://camlp5.github.io/"
SRC_URI="https://github.com/camlp5/camlp5/archive/rel$(ver_rs 1- '').tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-rel$(ver_rs 1- '')"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc +ocamlopt"

DEPEND="<dev-lang/ocaml-4.11.0:=[ocamlopt?]"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED=(
	/usr/bin/camlp5o.opt
	/usr/bin/camlp5r.opt
)

DOCS="CHANGES DEVEL ICHANGES README.md UPGRADING MODE"

src_configure() {
	./configure \
		--strict \
		-prefix /usr \
		-bindir /usr/bin \
		-libdir /usr/$(get_libdir)/ocaml \
		-mandir /usr/share/man || die "configure failed"
}

src_compile() {
	ulimit -s 11530000
	emake out
	if use ocamlopt; then
		emake  opt
		emake  opt.opt
	fi
}

src_install() {
	use doc && HTML_DOCS="doc/*"

	default

	# findlib support
	insinto "$(ocamlfind printconf destdir)/${PN}"
	doins etc/META
}
