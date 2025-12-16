# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_VERIFY_REPO=https://github.com/omnilib/aioitertools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="itertools and builtins for AsyncIO and mixed iterables"
HOMEPAGE="
	https://aioitertools.omnilib.dev/
	https://github.com/omnilib/aioitertools/
	https://pypi.org/project/aioitertools/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"

python_test() {
	"${EPYTHON}" -m aioitertools.tests || die
}
