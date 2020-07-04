# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib eutils

DESCRIPTION="Error-recovering streaming HTML5 and XML parsers"
HOMEPAGE="https://github.com/aantron/markup.ml"
SRC_URI="https://github.com/aantron/markup.ml/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}p1"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-lang/ocaml:=[ocamlopt]
	dev-ml/lwt:=[ocamlopt(+)]
	>=dev-ml/uutf-1.0:=[ocamlopt]
"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? ( dev-ml/ounit )
	dev-ml/ocamlbuild"
S="${WORKDIR}/${PN}.ml-${PV}"

src_compile() {
	emake
	use doc && emake docs
}

src_install() {
	findlib_src_preinst
	emake ocamlfind-install
	dodoc README.md
	use doc && dohtml doc/html/*
}
