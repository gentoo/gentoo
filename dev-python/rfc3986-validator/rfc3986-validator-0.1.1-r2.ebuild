# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Pure python RFC3986 validator"
HOMEPAGE="
	https://pypi.org/project/rfc3986-validator/
	https://github.com/naimetti/rfc3986-validator
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

# not a typo, it actually test-depends on rfc3987, and not rfc3986
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/rfc3987[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# remove dep on pytest-runner
	sed -i -r "s:('|\")pytest-runner('|\")(,|)::" setup.py || die
	distutils-r1_python_prepare_all
}
