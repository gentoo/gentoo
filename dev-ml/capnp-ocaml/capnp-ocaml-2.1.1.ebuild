# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib eutils

DESCRIPTION="OCaml code generator plugin for the Cap'n Proto serialization framework"
HOMEPAGE="https://github.com/pelzlpj/capnp-ocaml"
SRC_URI="https://github.com/pelzlpj/capnp-ocaml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-lang/ocaml:=[ocamlopt]
	dev-ml/core_kernel:=
	dev-ml/camlp4:=
	dev-ml/ocaml-extunix:=
	dev-ml/ocplib-endian:=
	dev-ml/res:=
	dev-ml/ocaml-uint:=
"
DEPEND="${RDEPEND}
	dev-util/omake
"

src_prepare() {
	epatch "${FILESDIR}/mi.patch"
}

src_compile() {
	PREFIX="${EPREFIX}/usr" omake --force-dotomake || die
}

src_install() {
	findlib_src_preinst
	DESTDIR="${D}" PREFIX="${EPREFIX}/usr" omake --force-dotomake install || die
	dodoc README.adoc CHANGELOG.adoc
}
