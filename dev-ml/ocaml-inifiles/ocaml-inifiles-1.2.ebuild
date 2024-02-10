# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="A small OCaml library to read and write .ini files"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/universe/o/${PN}/${PN}_${PV}.orig.tar.gz"
S="${WORKDIR}/inifiles-${PV}"

LICENSE="LGPL-2.1+"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

RDEPEND="dev-ml/pcre-ocaml:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-inifiles.ml.patch
	"${FILESDIR}"/${P}-shuffle.patch
)

src_compile() {
	emake -j1
	use ocamlopt && emake -j1 opt
}

src_install() {
	findlib_src_install
}
