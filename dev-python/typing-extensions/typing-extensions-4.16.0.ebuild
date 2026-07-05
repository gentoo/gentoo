# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYPI_VERIFY_REPO=https://github.com/python/typing_extensions
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="Backported and Experimental Type Hints for Python 3.7+"
HOMEPAGE="
	https://pypi.org/project/typing-extensions/
	https://github.com/python/typing_extensions/
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-python/flit-core-3.11[${PYTHON_USEDEP}]
	test? (
		dev-python/test[${PYTHON_USEDEP}]
	)
"

# TODO: switch back to unittests once we don't need deselects
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	cd src || die
	epytest
}
