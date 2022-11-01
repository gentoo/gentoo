# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Set of extensions to Ian Bicking's virtualenv tool"
HOMEPAGE="https://bitbucket.org/dhellmann/virtualenvwrapper
	https://pypi.org/project/virtualenvwrapper/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

# testsuite doesn't work out of the box.  Demand of a virtualenv outstrips setup by the eclass
RESTRICT=test

RDEPEND="
	dev-python/virtualenv[${PYTHON_USEDEP}]
	dev-python/stevedore[${PYTHON_USEDEP}]
	dev-python/virtualenv-clone[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]"

src_prepare() {
	default
	sed -i -e 's/egrep/grep -E/' "${S}/virtualenvwrapper.sh" || die
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	bash ./tests/run_tests || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	find "${D}" -name '*.pth' -delete || die
}
