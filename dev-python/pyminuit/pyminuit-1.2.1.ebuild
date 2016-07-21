# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Minuit numerical function minimization in Python"
HOMEPAGE="https://github.com/jpivarski/pyminuit"
SRC_URI="
	https://pyminuit.googlecode.com/files/${P}.tgz
	https://pyminuit.googlecode.com/files/Minuit-1_7_9-patch1.tar.gz
	"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"/${PN}

src_configure() {
	cd "${WORKDIR}"/Minuit-1_7_9 && econf --disable-static || die
}
src_compile() {
	cd "${WORKDIR}"/Minuit-1_7_9 && emake
	cd "${S}"
	distutils-r1_src_compile
}

python_install_all() {
	cd "${WORKDIR}"/Minuit-1_7_9 || die
	default
	distutils-r1_python_install_all
}
