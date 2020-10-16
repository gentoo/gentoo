# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6,7,8} )

inherit eutils distutils-r1

DESCRIPTION="An implementation of JSON Reference for Python"
HOMEPAGE="https://github.com/gazpachoking/jsonref https://pypi.org/project/jsonref/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	pytest -vv tests.py || die
}
