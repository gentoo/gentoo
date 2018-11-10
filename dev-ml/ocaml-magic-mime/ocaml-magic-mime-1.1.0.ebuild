# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Convert file extensions to MIME types"
HOMEPAGE="https://github.com/mirage/ocaml-magic-mime"
SRC_URI="https://github.com/mirage/ocaml-magic-mime/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-lang/ocaml:="
DEPEND="${RDEPEND}
	dev-ml/jbuilder
	dev-ml/opam
"

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		magic-mime.install || die
}
