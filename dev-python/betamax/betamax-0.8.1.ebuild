# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python{2_7,3_{6,7,8,9}} pypy3 )

inherit distutils-r1

DESCRIPTION="python-requests HTTP exchanges recorder"
HOMEPAGE="https://github.com/sigmavirus24/betamax"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="test"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		${RDEPEND}
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 pypy)
	)"

PATCHES=(
	"${FILESDIR}/betamax-0.8.1-tests.patch"
)

distutils_enable_tests pytest

src_prepare() {
	rm tests/integration/test_hooks.py || die
	rm tests/integration/test_placeholders.py || die
	sed -e 's:test_records:_&:' \
		-e 's:test_replaces:_&:' \
		-e 's:test_replays:_&:' \
		-e 's:test_creates:_&:' \
		-i tests/integration/test_record_modes.py || die
	rm tests/integration/test_unicode.py || die
	rm tests/regression/test_gzip_compression.py || die
	rm tests/regression/test_requests_2_11_body_matcher.py || die
	distutils-r1_src_prepare
}
