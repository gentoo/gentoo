# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit opam

DESCRIPTION="Resizable Array and Buffer modules for O'Caml"
HOMEPAGE="http://mmottl.github.io/res/"
SRC_URI="https://github.com/mmottl/res/releases/download/${PV}/${P}.tbz"
LICENSE="LGPL-2.1-with-linking-exception"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-ml/jbuilder
	>=dev-ml/findlib-1.5"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_compile() {
	jbuilder build @install || die
}
