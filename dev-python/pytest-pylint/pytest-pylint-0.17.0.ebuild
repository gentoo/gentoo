# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..8} )

inherit distutils-r1

DESCRIPTION="pytest plugin to check source code with pylint"
HOMEPAGE="https://github.com/carsongee/pytest-pylint"
# Tests should be included in PyPI tarballs by the next release:
# https://github.com/carsongee/pytest-pylint/commit/4e7f06701ca06697a22a029db9857fa2fdf7c033
SRC_URI="https://github.com/carsongee/pytest-pylint/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/pylint-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-5.4[${PYTHON_USEDEP}]
	>=dev-python/toml-0.7.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# Disable flake8 and pep8 options
	sed -i -e '/^addopts =/d' tox.ini || die
	# Remove pytest-runner requirement
	sed -i -e "s/'pytest-runner'//" setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# Required to load the pytest-pylint plugin
	distutils_install_for_testing
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
