# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/.}
PYPI_VERIFY_REPO=https://github.com/zopefoundation/zc.lockfile
PYTHON_COMPAT=( python3_{12..15} python3_{14,15}t )

inherit distutils-r1 pypi

DESCRIPTION="Basic inter-process locks"
HOMEPAGE="
	https://github.com/zopefoundation/zc.lockfile/
	https://pypi.org/project/zc.lockfile/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/zope-testing[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGES.rst README.rst )

distutils_enable_tests unittest

python_compile() {
	distutils-r1_python_compile
	rm "${BUILD_DIR}/install$(python_get_sitedir)/zc/lockfile/README.rst" || die
}

python_test() {
	"${EPYTHON}" -m unittest zc.lockfile.tests -v || die "Tests failed with ${EPYTHON}"
}
