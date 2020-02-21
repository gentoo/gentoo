# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Capture C-level stdout/stderr in Python"
HOMEPAGE="https://github.com/minrk/wurlitzer https://pypi.org/project/wurlitzer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"
distutils_enable_tests pytest

python_test() {
	pytest -vv test.py || die "Tests fail with ${EPYTHON}"
}
