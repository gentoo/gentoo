# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Show where your regex match assertion failed"
HOMEPAGE="
	https://github.com/asottile/re-assert/
	https://pypi.org/project/re-assert/
"
SRC_URI="
	https://github.com/asottile/re-assert/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/regex[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
