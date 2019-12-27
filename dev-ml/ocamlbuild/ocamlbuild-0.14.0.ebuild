# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Generic build tool with built-in rules for building OCaml library and programs"
HOMEPAGE="https://github.com/ocaml/ocamlbuild"
SRC_URI="https://github.com/ocaml/ocamlbuild/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+ocamlopt test"
RESTRICT="!test? ( test )"

DEPEND=">=dev-lang/ocaml-4.02.3-r1:=[ocamlopt?]"
RDEPEND="${DEPEND}
	!<dev-ml/findlib-1.6.1-r1
"
DEPEND="${DEPEND}
	test? ( dev-ml/findlib )"

src_configure() {
	emake -f configure.make Makefile.config \
		PREFIX="${EPREFIX}/usr" \
		BINDIR="${EPREFIX}/usr/bin" \
		LIBDIR="$(ocamlc -where)" \
		OCAML_NATIVE=$(usex ocamlopt true false) \
		OCAML_NATIVE_TOOLS=$(usex ocamlopt true false) \
		NATDYNLINK=$(usex ocamlopt true false)
}

src_install() {
	emake CHECK_IF_PREINSTALLED=false DESTDIR="${D}" install
	dodoc Changes
}
