# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy)

inherit distutils-r1

MY_PN="h2"

DESCRIPTION="HTTP/2 State-Machine based protocol implementation"
HOMEPAGE="http://python-hyper.org/h2 https://pypi.python.org/pypi/h2"
SRC_URI="mirror://pypi/${P:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/hyperframe-4.0.1[${PYTHON_USEDEP}]
	<dev-python/hyperframe-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/hpack-2.2.0[${PYTHON_USEDEP}]
	<dev-python/hpack-3.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/enum34-1.0.4[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep '<dev-python/enum34-2.0.0[${PYTHON_USEDEP}]' python2_7)
"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-2.9.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.3.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.14.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-3.4.2[${PYTHON_USEDEP}]
	)
"

S=${WORKDIR}/${MY_PN}-${PV}

# missing files in tarball to run tests properly
# upstream issue: https://github.com/python-hyper/hyper-h2/issues/371
RESTRICT=test

python_test() {
	PYTHONPATH="${S}/test:${BUILD_DIR}/lib" py.test -v || die "Tests failed under ${EPYTHON}"
	cd test
}
