# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="The transitory OCaml software packager"
HOMEPAGE="http://erratique.ch/software/topkg https://github.com/dbuenzli/topkg"
SRC_URI="https://github.com/dbuenzli/topkg/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE=""

RDEPEND="dev-ml/result:=
	dev-ml/ocamlbuild:=
	dev-ml/findlib:=
	dev-lang/ocaml:="
DEPEND="${RDEPEND}"

src_compile() {
	ocaml pkg/pkg.ml build --pkg-name ${PN} || die
}

src_install() {
	# Can't use opam-installer here as it is an opam dep...
	findlib_src_preinst
	local nativelibs="$(echo _build/src/${PN}*.cm{x,xa,xs,ti} _build/src/${PN}.a)"
	ocamlfind install ${PN} _build/pkg/META _build/src/${PN}.mli _build/src/${PN}.cm{a,i} ${nativelibs} || die
	dodoc CHANGES.md DEVEL.md README.md
}
