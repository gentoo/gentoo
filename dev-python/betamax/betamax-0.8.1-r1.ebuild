# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} pypy3 )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="python-requests HTTP exchanges recorder"
HOMEPAGE="https://github.com/betamaxpy/betamax"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"

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
