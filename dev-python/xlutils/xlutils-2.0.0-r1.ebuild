# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="provides a collection of utilities for working with Excel files"
HOMEPAGE="https://pypi.org/project/xlutils/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=dev-python/xlwt-1.3[${PYTHON_USEDEP}]
	>=dev-python/xlrd-1.2[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? (
		>=dev-python/errorhandler-2[${PYTHON_USEDEP}]
		>=dev-python/manuel-1.9[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/testfixtures[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-fix-tests.patch"
)

python_test() {
	# upstream runs its tests with nose, but the suite actually runs better
	# when ran through pytest...
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
