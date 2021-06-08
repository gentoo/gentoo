# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Show where your regex match assertion failed"
HOMEPAGE="https://github.com/asottile/re-assert"
SRC_URI="
	https://github.com/asottile/re-assert/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~x64-macos"

RDEPEND="dev-python/regex[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
