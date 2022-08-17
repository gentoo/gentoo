# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="pKa-value prediction of ionizable groups in protein and protein-ligand complexes"
HOMEPAGE="https://github.com/jensengroup/propka"
SRC_URI="https://github.com/jensengroup/propka/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	# Do not install the tests
	sed -e "/exclude/s:scripts:\', \'tests:g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}
