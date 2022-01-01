# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Composable style cycles"
HOMEPAGE="
	https://matplotlib.org/cycler/
	https://pypi.org/project/cycler/
	https://github.com/matplotlib/cycler"
SRC_URI="
	https://github.com/matplotlib/cycler/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

distutils_enable_tests pytest
