# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy{,3} python{2_7,3_{5,6,7}} )

inherit distutils-r1

DESCRIPTION="Python library providing a few tools handling SemVer in Python"
HOMEPAGE="https://pypi.org/project/semantic_version/"
SRC_URI="https://github.com/rbarrois/python-semanticversion/archive/v${PV}.tar.gz -> ${P}-1.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/python-${P/_/}"

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# The django test hangs
	py.test --ignore tests/test_django.py\
		|| die "tests failed with ${EPYTHON}"
}
