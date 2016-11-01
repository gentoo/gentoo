# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 pypy )

inherit distutils-r1

DESCRIPTION="Best way to have Django DRY forms"
HOMEPAGE="https://pypi.python.org/pypi/django-crispy-forms/ https://github.com/maraujop/django-crispy-forms https://django-crispy-forms.readthedocs.org/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

# Missing DjangoTestSuiteRunner in django
RESTRICT=test

python_test() {
	cd crispy_forms/tests || die
	${PYTHON} runtests.py || die
}
