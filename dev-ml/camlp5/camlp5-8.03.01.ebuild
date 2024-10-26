# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib vcs-clean

DESCRIPTION="A preprocessor-pretty-printer of ocaml"
HOMEPAGE="https://camlp5.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="doc +ocamlopt"

RDEPEND="
	dev-ml/bos:=
	dev-ml/camlp-streams:=[ocamlopt?]
	dev-ml/fmt:=[ocamlopt?]
	dev-ml/fpath:=
	dev-ml/logs:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
	dev-ml/rresult:=
"
DEPEND="${RDEPEND}"

src_prepare() {
	egit_clean
	default
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
	ulimit -s 11530000
	emake out
	if use ocamlopt; then
		emake opt
		emake opt.opt
	fi
}

src_test() {
	ulimit -s 11530000
	emake bootstrap
	if use ocamlopt; then
		emake opt
		emake opt.opt
	fi
}

src_install() {
	emake DESTDIR="${ED}" install
	# findlib support
	insinto "$(ocamlfind printconf destdir)/${PN}"
	doins etc/META

	dodoc -r doc/*
	dodoc CHANGES DEVEL ICHANGES README.md UPGRADING MODE
}
