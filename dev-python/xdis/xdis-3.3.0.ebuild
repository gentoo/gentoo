# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy)

inherit distutils-r1

DESCRIPTION="Python cross-version byte-code disassembler and marshal routines"
HOMEPAGE="https://github.com/rocky/python-xdis/ https://pypi.python.org/pypi/xdis"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/six-1.10.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/nose-1.0[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}/xdis-test_magic_bytes_error.patch"
	"${FILESDIR}/xdis-3.3.0-remove-pytest-runner-dep.patch"
)

python_test() {
	# Need to rm any pyc files to prevent test failures.
	rm -R "${S}"/test/__pycache__
	PYTHONPATH="${S}/test:${S}/test_unit:${BUILD_DIR}/lib" \
		py.test -v || die "Tests failed under ${EPYTHON}"
	cd test
	PYTHONPATH="${S}/test:${BUILD_DIR}/lib" \
		${EPYTHON} test_pyenvlib.py --verify --simple --compile || die \
		"Tests failed under ${EPYTHON}"
}
