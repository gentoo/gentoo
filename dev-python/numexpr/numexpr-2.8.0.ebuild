# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Fast numerical array expression evaluator for Python and NumPy"
HOMEPAGE="https://github.com/pydata/numexpr"
SRC_URI="https://github.com/pydata/numexpr/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-python/numpy-1.6[${PYTHON_USEDEP}]
"
RDEPEND=${DEPEND}

python_test() {
	pushd "${BUILD_DIR}"/lib >/dev/null || die
	"${EPYTHON}" \
		-c "import sys,numexpr; sys.exit(0 if numexpr.test().wasSuccessful() else 1)" \
		|| die
	pushd >/dev/null || die
}
