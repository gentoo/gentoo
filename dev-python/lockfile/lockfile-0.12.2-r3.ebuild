# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Platform-independent file locking module"
HOMEPAGE="
	https://launchpad.net/pylockfile/
	https://pypi.org/project/lockfile/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	>dev-python/pbr-1.8[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${P}-pytest.patch
)

distutils_enable_tests pytest
distutils_enable_sphinx doc/source --no-autodoc
