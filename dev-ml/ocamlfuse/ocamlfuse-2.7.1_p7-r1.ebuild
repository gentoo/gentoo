# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune toolchain-funcs

MYPV="${PV/_p/_cvs}"

DESCRIPTION="OCaml binding for fuse"
HOMEPAGE="
	https://sourceforge.net/projects/ocamlfuse/
	https://github.com/astrada/ocamlfuse
	https://opam.ocaml.org/packages/ocamlfuse
"
SRC_URI="https://github.com/astrada/${PN}/archive/v${MYPV}.tar.gz -> ${PF}.tar.gz"
S="${WORKDIR}/${PN}-${MYPV}"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="ocamlopt"

RDEPEND="
	dev-ml/camlidl:=
	sys-fs/fuse:0
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-ml/dune-configurator
	dev-ml/opam
"

PATCHES=( "${FILESDIR}"/${P}-unistd.patch )

src_compile() {
	tc-export CPP
	dune_src_compile
}
