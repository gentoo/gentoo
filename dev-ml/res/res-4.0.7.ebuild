# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="Resizable Array and Buffer modules for O'Caml"
HOMEPAGE="http://mmottl.github.io/res/"
SRC_URI="https://github.com/mmottl/res/releases/download/v${PV}/${P}.tar.gz"
LICENSE="LGPL-2.1-with-linking-exception"

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-ml/findlib-1.5"
SLOT="0/${PV}"
KEYWORDS="amd64 ppc x86"
IUSE="examples"

DOCS=( "AUTHORS.txt" "CHANGES.txt" "README.md" )

src_install() {
	oasis_src_install
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
