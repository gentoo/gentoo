# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Prediction of the pKa values of ionizable groups in proteins and protein-ligand complexes"
HOMEPAGE="http://propka.ki.ku.dk/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RESTRICT="mirror bindist"

python_prepare_all() {
	sed -e "/exclude/s:scripts:\', \'Tests:g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	cd Tests || die
	${PYTHON} runtest.py || die
}

python_install_all() {
	dosym ${PN}31 /usr/bin/${PN}
	distutils-r1_python_install_all
}
