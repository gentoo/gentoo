# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Easily freeze time in pytest test + fixtures"
HOMEPAGE="https://github.com/ktosiek/pytest-freezegun"
SRC_URI="
	https://github.com/ktosiek/pytest-freezegun/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~x64-macos"

RDEPEND="
	dev-python/freezegun[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]"

distutils_enable_tests --install pytest
