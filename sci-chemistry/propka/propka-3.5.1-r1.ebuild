# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="pKa-value prediction of ionizable groups in protein and protein-ligand complexes"
HOMEPAGE="https://github.com/jensengroup/propka"
SRC_URI="https://github.com/jensengroup/propka/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${PN}-3.5.1-python3.14.patch"
)

python_prepare_all() {
	# Do not install the tests
	sed -e "/exclude/s:scripts:\', \'tests:g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	epytest -k 'not test_molecular_container'
}
