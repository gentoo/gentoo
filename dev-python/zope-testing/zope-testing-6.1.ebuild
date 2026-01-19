# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/.}
PYTHON_TESTED=( python3_{11..14} python3_{13..14}t pypy3_11 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )

inherit distutils-r1 pypi

DESCRIPTION="Zope testing helpers"
HOMEPAGE="
	https://pypi.org/project/zope.testing/
	https://github.com/zopefoundation/zope.testing/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

distutils_enable_tests unittest

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
