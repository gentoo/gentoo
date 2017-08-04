# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit opam

DESCRIPTION="Partially Ordered Map ADT for O'Caml"
HOMEPAGE="http://mmottl.github.io/pomap/"
SRC_URI="https://github.com/mmottl/pomap/releases/download/${PV}/${P}.tbz"
LICENSE="LGPL-2.1-with-linking-exception"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND} dev-ml/jbuilder"

src_compile() {
	jbuilder build @install || die
}
