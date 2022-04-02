# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Requirements Support For Setuptools Declarative setup.cfg"
HOMEPAGE="
	https://pypi.org/project/setuptools-declarative-requirements/
	https://github.com/s0undt3ch/setuptools-declarative-requirements
"
SRC_URI="https://github.com/s0undt3ch/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/pypiserver[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -e "s/use_scm_version=True/version='${PV}'/" -i setup.py || die
	sed -e "/setuptools_scm/ d" -i setup.cfg || die
	printf '__version__ = "${PV}"\n' > declarative_requirements/version.py || die
	sed -e "s/localhost/127.0.0.1/g" -i tests/conftest.py || die
	rm pyproject.toml || die

	distutils-r1_python_prepare_all
}

python_test() {
	PIP_DEFAULT_TIMEOUT=3 \
		PIP_INDEX_URL="http://127.0.0.1:8080" \
		epytest -k 'not sdist'
}
