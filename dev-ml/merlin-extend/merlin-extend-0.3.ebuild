# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib

DESCRIPTION="SDK to extend Merlin"
HOMEPAGE="https://github.com/let-def/merlin-extend"
SRC_URI="https://github.com/let-def/merlin-extend/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"

DEPEND="dev-lang/ocaml:0/4.05.0"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/cppo"

src_install() {
	findlib_src_preinst
	default
}
