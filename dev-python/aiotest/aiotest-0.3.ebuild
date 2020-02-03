# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Test suite for an implementation of asyncio (PEP 3156)"
HOMEPAGE="https://bitbucket.org/haypo/aiotest"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" "test_asyncio.py" || die "Tests fail with ${EPYTHON}"
}
