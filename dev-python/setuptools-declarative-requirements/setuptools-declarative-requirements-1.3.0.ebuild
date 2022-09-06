# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Requirements Support For Setuptools Declarative setup.cfg"
HOMEPAGE="
	https://pypi.org/project/setuptools-declarative-requirements/
	https://github.com/s0undt3ch/setuptools-declarative-requirements
"
SRC_URI="
	https://github.com/s0undt3ch/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/pypiserver[${PYTHON_USEDEP}]
		dev-python/pytest-shell-utilities[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_prepare_all() {
	sed -e "/http/s/localhost/127.0.0.1/g" -i tests/conftest.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x PIP_DEFAULT_TIMEOUT=3
	local -x PIP_INDEX_URL="http://127.0.0.1:8080"
	epytest -k 'not sdist'
}
