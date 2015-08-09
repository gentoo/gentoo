# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="Generator for psychophysical experiments"
HOMEPAGE="http://www.flashdot.info/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
		 http://dev.gentoo.org/~tomka/files/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="+ocamlopt"

DEPEND=">=dev-lang/ocaml-3.10[ocamlopt?]
	dev-ml/ocamlsdl
	dev-ml/ocamlgsl
	dev-ml/lablgl[glut]
	x11-apps/xdpyinfo"
RDEPEND="${DEPEND}"

MAKEOPTS="-j1 VERSION=${PV}"
use ocamlopt || MAKEOPTS="${MAKEOPTS} TARGETS=flashdot_bytecode BYTECODENAME=flashdot"

src_compile() {
	emake ${MAKEOPTS} || die "emake failed"
}

src_install() {
	emake ${MAKEOPTS} DESTDIR="${D}" CALLMODE=script install || die "install failed"
}
