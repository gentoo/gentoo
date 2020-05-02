# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Automatically mock your HTTP interactions to simplify and speed up testing"
HOMEPAGE="https://github.com/kevin1024/vcrpy"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/kevin1024/vcrpy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/httplib2-0.9.1[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/six-1.5[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	dev-python/yarl[${PYTHON_USEDEP}]
	"
BDEPEND="
	test? (
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	# tests requiring Internet
	rm tests/integration/test_aiohttp.py || die
	sed -e 's:test_flickr_should_respond_with_200:_&:' \
		-e 's:test_amazon_doctype:_&:' \
		-i tests/integration/test_wild.py || die
	sed -e 's:testing_connect:_&:' \
		-i tests/unit/test_stubs.py || die

	distutils-r1_src_prepare
}

python_test() {
	local -x REQUESTS_CA_BUNDLE=$("${EPYTHON}" -m pytest_httpbin.certs)
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
