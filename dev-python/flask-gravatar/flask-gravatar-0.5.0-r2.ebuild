# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
PYPI_NO_NORMALIZE=1
PYPI_PN="Flask-Gravatar"

inherit distutils-r1 pypi

DESCRIPTION="Small extension for Flask to make usage of Gravatar service easy"
HOMEPAGE="
	https://github.com/zzzsochi/Flask-Gravatar/
	https://pypi.org/project/Flask-Gravatar/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	<dev-python/flask-3[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/pytest-runner/d' setup.py || die
	sed -e 's:--pep8::' \
		-e 's:--cov=flask_gravatar --cov-report=term-missing::' \
		-i pytest.ini || die
	distutils-r1_src_prepare
}

python_test() {
	cd tests || die
	epytest
}
