# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib eutils

MY_PV=$(ver_rs 2 '+')
DESCRIPTION="Tools for authors of ppx rewriters"
HOMEPAGE="https://github.com/alainfrisch/ppx_tools"
SRC_URI="https://github.com/alainfrisch/ppx_tools/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="+ocamlopt"

DEPEND="dev-lang/ocaml:=[ocamlopt?]"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}-$(ver_rs 2 '-')"

src_compile() {
	emake -j1 $(usex ocamlopt "" "ARCH=none")
}

src_install() {
	findlib_src_install
	dodoc README.md
}
