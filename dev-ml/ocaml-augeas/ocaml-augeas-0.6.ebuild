# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib

DESCRIPTION="Ocaml bindings for Augeas"
HOMEPAGE="http://augeas.net/"
#SRC_URI="http://augeas.net/download/ocaml/${P}.tar.gz"
SRC_URI="https://people.redhat.com/~rjones/augeas/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-admin/augeas
	dev-libs/libxml2
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-ml/findlib
	dev-ml/ocaml-autoconf
	dev-lang/ocaml[ocamlopt]
"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-ocaml-4.09.patch
)

src_compile() {
	emake -j1
}

src_install() {
	findlib_src_install
}
