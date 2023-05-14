# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Describe-style plugin for pytest"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-describe/
	https://pypi.org/project/pytest-describe/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	<dev-python/pytest-8[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.6.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	# We need to disable some plugins because tests don't like unexpected
	# output
	PYTEST_ADDOPTS="-p no:flaky -p no:capturelog" epytest
}
