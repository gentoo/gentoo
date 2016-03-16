# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit findlib

DESCRIPTION="Tools for authors of ppx rewriters"
HOMEPAGE="https://github.com/alainfrisch/ppx_tools"
SRC_URI="https://github.com/alainfrisch/ppx_tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/ocaml-4.03.0_beta:="
RDEPEND="${DEPEND}"

src_compile() {
	emake -j1
}

src_install() {
	findlib_src_install
	dodoc README.md
}
