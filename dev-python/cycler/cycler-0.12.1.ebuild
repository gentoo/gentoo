# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="Composable style cycles"
HOMEPAGE="
	https://matplotlib.org/cycler/
	https://pypi.org/project/cycler/
	https://github.com/matplotlib/cycler/
"
SRC_URI="
	https://github.com/matplotlib/cycler/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"

distutils_enable_tests pytest
