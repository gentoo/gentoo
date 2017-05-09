# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib

DESCRIPTION="Overlay over bigarrays of chars"
HOMEPAGE="https://github.com/c-cube/ocaml-bigstring/"
SRC_URI="https://github.com/c-cube/ocaml-bigstring/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"

# ocamlfind: Package `QTest2Lib' not found
RESTRICT="test"

RDEPEND="
	dev-lang/ocaml:=
"
DEPEND="${RDEPEND}
	dev-ml/ocamlbuild
	test? ( dev-ml/iTeML )
"

src_install() {
	findlib_src_preinst
	default
}
