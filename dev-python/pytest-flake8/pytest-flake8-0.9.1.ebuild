# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="py.test plugin for flake8"
HOMEPAGE="https://github.com/tholo/pytest-flake8 https://pypi.org/project/pytest-flake8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND="
	>=dev-python/flake8-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	pytest -v || die "tests failed with ${EPYTHON}"
}
