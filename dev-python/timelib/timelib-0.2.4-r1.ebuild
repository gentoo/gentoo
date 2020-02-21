# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="parse english textual date descriptions"
HOMEPAGE="https://github.com/pediapress/timelib https://pypi.org/project/timelib/"
# pypi zipball lacks tests; also it's .zip
SRC_URI="https://github.com/pediapress/timelib/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="PHP-3.01 ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	py.test -v || die "Tests fail with ${EPYTHON}"
}
