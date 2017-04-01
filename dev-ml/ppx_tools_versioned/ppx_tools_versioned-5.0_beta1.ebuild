# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit findlib

MY_PV=${PV/_/}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Tools for authors of ppx rewriters"
HOMEPAGE="https://github.com/let-def/ppx_tools_versioned"
SRC_URI="https://github.com/let-def/ppx_tools_versioned/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-lang/ocaml:=
	dev-ml/ocaml-migrate-parsetree:=
"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"

src_install() {
	findlib_src_install
	dodoc README.md
}
