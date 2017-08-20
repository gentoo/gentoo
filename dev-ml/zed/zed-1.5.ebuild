# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit opam

DESCRIPTION="Zed is an abstract engine for text edition"
HOMEPAGE="https://github.com/diml/zed"
SRC_URI="https://github.com/diml/zed/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-lang/ocaml:=
	dev-ml/camomile:=
	dev-ml/react:="
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	dev-ml/jbuilder"

src_compile() {
	jbuilder build --only-packages zed @install || die
}
