# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Fast numerical array expression evaluator for Python and NumPy"
HOMEPAGE="
	https://github.com/pydata/numexpr/
	https://pypi.org/project/numexpr/
"
SRC_URI="https://github.com/pydata/numexpr/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"

DEPEND="
	>=dev-python/numpy-2.0.0_rc:=[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	dev-python/packaging[${PYTHON_USEDEP}]
"

python_test() {
	pushd "${BUILD_DIR}/install/$(python_get_sitedir)" >/dev/null || die
	"${EPYTHON}" -c '
import sys,numexpr
sys.exit(0 if numexpr.test(verbosity=2).wasSuccessful() else 1)
	' || die "Tests failed with ${EPYTHON}"
	pushd >/dev/null || die
}
