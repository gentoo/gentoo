# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1 pypi

DESCRIPTION="pytest plugin for flake8"
HOMEPAGE="
	https://github.com/tholo/pytest-flake8/
	https://pypi.org/project/pytest-flake8/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 x86"

RDEPEND="
	>=dev-python/flake8-4.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-7.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	epytest -p flake8
}
