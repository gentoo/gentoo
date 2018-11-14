# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Set of extensions to Ian Bicking's virtualenv tool"
HOMEPAGE="https://bitbucket.org/dhellmann/virtualenvwrapper
	https://pypi.org/project/virtualenvwrapper/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

# testsuite doesn't work out of the box.  Demand of a virtualenv outstrips setup by the eclass
RESTRICT=test

RDEPEND="
	dev-python/virtualenv[${PYTHON_USEDEP}]
	>=dev-python/stevedore-0.15-r1[${PYTHON_USEDEP}]
	dev-python/virtualenv-clone[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]"

# Keep just in case
python_prepare_all() {
	sed -e 's:-o shwordsplit::' -i tests/run_tests || die

	distutils-r1_python_prepare_all
}

python_test() {
	bash ./tests/run_tests || die "Tests failed under ${EPYTHON}"
}
