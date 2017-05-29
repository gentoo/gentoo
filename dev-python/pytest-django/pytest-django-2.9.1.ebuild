# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="A Django plugin for py.test"
HOMEPAGE="https://pypi.python.org/pypi/pytest-django https://pytest-django.readthedocs.org https://github.com/pytest-dev/pytest-django"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.8.0[${PYTHON_USEDEP}]
"

# https://github.com/pytest-dev/pytest-django/issues/290
RESTRICT=test

src_prepare() {
	sed \
		-e '/setuptools_scm/s:==1.8.0::g' \
		-i setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	PYTEST_PLUGINS=${PN/-/_} \
	py.test --ds=pytest_django_test.settings_sqlite_file --strict -r fEsxXw || die
}
