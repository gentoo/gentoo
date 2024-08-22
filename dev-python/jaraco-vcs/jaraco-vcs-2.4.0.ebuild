# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Facilities for working with VCS repositories"
HOMEPAGE="
	https://github.com/jaraco/jaraco.vcs/
	https://pypi.org/project/jaraco.vcs/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/jaraco-classes[${PYTHON_USEDEP}]
	dev-python/jaraco-path[${PYTHON_USEDEP}]
	dev-python/jaraco-versioning[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/tempora[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-home[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# assumes running inside the git repo
		jaraco/vcs/__init__.py::jaraco.vcs
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p home -p jaraco.vcs.fixtures
}
