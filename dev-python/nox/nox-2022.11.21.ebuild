# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Flexible test automation for Python"
HOMEPAGE="
	https://github.com/wntrblm/nox/
	https://pypi.org/project/nox/
"
SRC_URI="
	https://github.com/wntrblm/nox/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	<dev-python/argcomplete-3.0[${PYTHON_USEDEP}]
	>=dev-python/argcomplete-1.9.4[${PYTHON_USEDEP}]
	<dev-python/colorlog-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/colorlog-2.6.1[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.9[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-14[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/py[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# broken with >=dev-python/tox-4
	# https://github.com/wntrblm/nox/issues/673
	rm nox/tox_to_nox.* tests/test_tox_to_nox.py || die
	sed -i -e '/tox-to-nox/d' pyproject.toml || die
	distutils-r1_src_prepare
}
