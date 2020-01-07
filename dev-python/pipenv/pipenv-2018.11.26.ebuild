# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python Development Workflow for Humans"
HOMEPAGE="https://github.com/pypa/pipenv https://pypi.org/project/pipenv/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-clone-0.2.5[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pip-9.0.1[${PYTHON_USEDEP}]
	>dev-python/requests-2.18.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.21.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' 'python2_7')
	$(python_gen_cond_dep 'dev-python/typing[${PYTHON_USEDEP}]' 'python2_7')
	$(python_gen_cond_dep 'dev-python/pathlib[${PYTHON_USEDEP}]' 'python2_7')
	$(python_gen_cond_dep 'dev-python/backports-shutil_get_terminal_size[${PYTHON_USEDEP}]' 'python2_7')
	"
DEPEND="
	>=dev-python/parver-0.2[${PYTHON_USEDEP}]
	dev-python/invoke[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

# not completely packed
# requires networking
RESTRICT="test"

python_test() {
	py.test -v -v || die
}
