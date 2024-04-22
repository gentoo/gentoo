# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="ISO 8601 date/time/duration parser and formatter"
HOMEPAGE="
	https://github.com/gweis/isodate/
	https://pypi.org/project/isodate/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_test() {
	eunittest -s "${BUILD_DIR}/install$(python_get_sitedir)/isodate"
}
