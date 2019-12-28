# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )
inherit distutils-r1

DESCRIPTION="Server to test HTTP clients"
HOMEPAGE="https://github.com/lorien/test_server https://pypi.org/project/test-server/"
SRC_URI="https://github.com/lorien/test_server/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/bottle-0.12.13[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/webtest[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# broken on py2.7, upstream knows
	sed -i -e '5a\
import sys' \
		-e '/test_null_bytes/i\
@pytest.mark.skipif(sys.hexversion < 0x03000000, reason="broken on py2")' \
		test/server.py || die
}
