# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Zed is an abstract engine for text edition"
HOMEPAGE="https://github.com/diml/zed"
SRC_URI="https://github.com/diml/zed/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-lang/ocaml:=
	dev-ml/camomile:=
	dev-ml/react:="
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/opam
	dev-ml/jbuilder"

src_compile() {
	jbuilder build --only-packages zed @install || die
}

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die
	dodoc CHANGES.md README.md
}
