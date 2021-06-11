# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

AT_M4DIR="m4"
inherit autotools findlib

DESCRIPTION="OCaml bindings for libbz (AKA, bzip2)"
HOMEPAGE="https://gitlab.com/irill/camlbz2"
SRC_URI="https://gitlab.com/irill/camlbz2/-/archive/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="doc"

DEPEND="
	app-arch/bzip2
	>=dev-lang/ocaml-3.12:=[ocamlopt]
"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog README ROADMAP BUGS )
HTML_DOCS=( doc/. )

src_prepare() {
	default

	mkdir m4 || die
	mv ocaml.m4 m4 || die

	eautoreconf
}

src_compile() {
	emake -j1 all
}

src_install() {
	findlib_src_preinst
	emake DESTDIR="${OCAMLFIND_DESTDIR}" install
	use doc && einstalldocs
}
