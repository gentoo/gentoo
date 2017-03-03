# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib versionator eutils

MY_PV=$(replace_version_separator 2 '+')
DESCRIPTION="Tools for authors of ppx rewriters"
HOMEPAGE="https://github.com/alainfrisch/ppx_tools"
SRC_URI="https://github.com/alainfrisch/ppx_tools/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/ocaml-4.05_beta:="
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}-$(replace_version_separator 2 '-')"

src_compile() {
	emake -j1
}

src_install() {
	findlib_src_install
	dodoc README.md
}
