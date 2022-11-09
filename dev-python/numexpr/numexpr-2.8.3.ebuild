# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Fast numerical array expression evaluator for Python and NumPy"
HOMEPAGE="https://github.com/pydata/numexpr"
SRC_URI="https://github.com/pydata/numexpr/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-python/numpy-1.13.3[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	dev-python/packaging[${PYTHON_USEDEP}]
"

python_test() {
	pushd "${BUILD_DIR}/install/usr/lib/${EPYTHON}/site-packages" >/dev/null || die
	"${EPYTHON}" - <<-EOF || die "Tests failed with ${EPYTHON}"
		import sys,numexpr
		sys.exit(0 if numexpr.test().wasSuccessful() else 1)
	EOF
	pushd >/dev/null || die
}
