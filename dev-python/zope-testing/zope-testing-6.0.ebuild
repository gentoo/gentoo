# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/.}
PYTHON_TESTED=( python3_{11..13} python3_13t pypy3_11 )
# py3.14 seems to have had some doctest changes recently
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" python3_14{,t} )

inherit distutils-r1 pypi

DESCRIPTION="Zope testing helpers"
HOMEPAGE="
	https://pypi.org/project/zope.testing/
	https://github.com/zopefoundation/zope.testing/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

distutils_enable_tests unittest

src_prepare() {
	local PATCHES=(
		# https://github.com/zopefoundation/zope.testing/pull/54
		"${FILESDIR}/${P}-test.patch"
	)

	distutils-r1_src_prepare

	# strip rdep specific to namespaces
	# https://github.com/zopefoundation/zope.testing/pull/53
	sed -i -e "/'setuptools'/d" setup.py || die
}

python_test() {
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	"${EPYTHON}" - <<-EOF || die
		import sys
		import unittest

		from zope.testing.tests import test_suite

		runner = unittest.TextTestRunner(verbosity=2)
		result = runner.run(test_suite())
		sys.exit(0 if result.wasSuccessful() else 1)
	EOF
}
