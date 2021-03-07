# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Generator for psychophysical experiments"
HOMEPAGE="http://www.flashdot.info/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	https://dev.gentoo.org/~tomka/files/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt"

DEPEND="
	>=dev-lang/ocaml-3.10[ocamlopt?]
	dev-ml/gsl-ocaml
	dev-ml/lablgl[glut]
	dev-ml/ocamlsdl
	x11-apps/xdpyinfo"
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}/${P}-gsl-ocaml.patch"
)

src_prepare() {
	default
	MAKEOPTS+=" -j1 VERSION=${PV}"
	use ocamlopt || MAKEOPTS+=" TARGETS=flashdot_bytecode BYTECODENAME=flashdot"
}

src_install() {
	emake DESTDIR="${D}" CALLMODE=script install
}
