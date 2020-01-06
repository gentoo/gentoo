# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6)

inherit distutils-r1

DESCRIPTION="Pure-Python HPACK header compression"
HOMEPAGE="https://python-hyper.org/hpack/en/latest/ https://pypi.org/project/hpack/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-2.9.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.3.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.14.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-3.4.2[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# Remove a test that is not part of the mainstream tests
	# Also, it's data directory is not included in the release
	rm test/test_hpack_integration.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH="${S}/test:${BUILD_DIR}/lib" \
		py.test -v hpack test/|| die
	cd test
}
