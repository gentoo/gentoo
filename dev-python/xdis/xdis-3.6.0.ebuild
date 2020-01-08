# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6)

inherit distutils-r1

DESCRIPTION="Python cross-version byte-code disassembler and marshal routines"
HOMEPAGE="https://github.com/rocky/python-xdis/ https://pypi.org/project/xdis/"
# bad pypi source tarball - test failures
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/rocky/python-xdis/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/nose-1.0[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/xdis-3.3.0-remove-pytest-runner-dep.patch"
)

S="${WORKDIR}/python-xdis-release-${PV}"

python_test() {
	# Need to rm any pyc files to prevent test failures.
	rm -R "${S}"/test/__pycache__
	PYTHONPATH="${S}/test:${S}/test_unit:${BUILD_DIR}/lib" \
		esetup.py test || die "Tests failed under ${EPYTHON}"
}
