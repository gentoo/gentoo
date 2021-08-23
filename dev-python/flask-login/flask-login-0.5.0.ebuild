# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Login session support for Flask"
HOMEPAGE="https://pypi.org/project/Flask-Login/"
# Should be replaced with the PyPi URI for the next release, if possible
# See https://github.com/maxcountryman/flask-login/pull/393
SRC_URI="https://github.com/maxcountryman/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~sparc x86"

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

PATCHES=(
	"${FILESDIR}/${P}-fix-tests-py3.10.patch"
)

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_test() {
	epytest -p no:httpbin
}
