# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6..9} )
inherit distutils-r1

DESCRIPTION="Login session support for Flask"
HOMEPAGE="https://pypi.org/project/Flask-Login/"
# Should be replaced with the PyPi URI for the next release, if possible
# See https://github.com/maxcountryman/flask-login/pull/393
SRC_URI="https://github.com/maxcountryman/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="
	>=dev-python/flask-0.10[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/blinker[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/semantic_version[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_test() {
	pytest -vv -p no:httpbin || die "Tests failed with ${EPYTHON}"
}
