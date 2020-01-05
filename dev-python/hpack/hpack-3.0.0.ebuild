# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{6,7,8})

inherit distutils-r1

DESCRIPTION="Pure-Python HPACK header compression"
HOMEPAGE="https://python-hyper.org/hpack/en/latest/ https://pypi.org/project/hpack/"
SRC_URI="https://github.com/python-hyper/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
# dev-python/pytest-relaxed causes tests to fail
DEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-2.9.2[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-3.4.2[${PYTHON_USEDEP}]
		!!dev-python/pytest-relaxed[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/hpack-3.0.0-hypothesis-healthcheck.patch
)

python_prepare_all() {
	# Remove a test that is not part of the mainstream tests
	# Also, it's data directory is not included in the release
	rm test/test_hpack_integration.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	pytest -vv hpack test || die "Tests fail with ${EPYTHON}"
}
