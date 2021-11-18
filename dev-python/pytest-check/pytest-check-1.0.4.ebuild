# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

DESCRIPTION="pytest plugin that allows multiple failures per test"
HOMEPAGE="https://github.com/okken/pytest-check https://pypi.org/project/pytest_check/"
SRC_URI="
	https://github.com/okken/pytest-check/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ~ppc64 sparc x86"

RDEPEND=">=dev-python/pytest-6[${PYTHON_USEDEP}]"
BDEPEND="dev-python/flit_core[${PYTHON_USEDEP}]"

distutils_enable_tests --install pytest

src_prepare() {
	default
	mv src/pytest_check pytest_check
}
