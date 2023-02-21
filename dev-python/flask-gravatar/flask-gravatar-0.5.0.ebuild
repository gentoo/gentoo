# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Flask-Gravatar"
MY_P=${MY_PN}-${PV}

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Small extension for Flask to make usage of Gravatar service easy"
HOMEPAGE="https://github.com/zzzsochi/Flask-Gravatar/"
SRC_URI="mirror://pypi/F/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]"

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
