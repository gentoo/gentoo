# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib

DESCRIPTION="SDK to extend Merlin"
HOMEPAGE="https://github.com/let-def/merlin-extend"
SRC_URI="https://github.com/let-def/merlin-extend/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/ocaml:="
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/cppo"

src_install() {
	findlib_src_preinst
	default
}
