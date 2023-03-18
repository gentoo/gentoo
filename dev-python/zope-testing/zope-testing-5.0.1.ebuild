# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Zope testing helpers"
HOMEPAGE="
	https://pypi.org/project/zope.testing/
	https://github.com/zopefoundation/zope.testing/
"
SRC_URI="$(pypi_sdist_url --no-normalize "${PN/-/.}")"
S=${WORKDIR}/${P/-/.}

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	!dev-python/namespace-zope
"

distutils_enable_tests unittest

src_prepare() {
	# strip rdep specific to namespaces
	sed -i -e "/'setuptools'/d" setup.py || die
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	distutils_write_namespace zope
	"${EPYTHON}" - <<-EOF || die
		import sys
		import unittest

		from zope.testing.tests import test_suite

		runner = unittest.TextTestRunner(verbosity=2)
		result = runner.run(test_suite())
		sys.exit(0 if result.wasSuccessful() else 1)
	EOF
}
