# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Yet Another Python Profiler"
HOMEPAGE="
	https://pypi.org/project/yappi/
	https://github.com/sumerc/yappi/
"
SRC_URI="
	https://github.com/sumerc/yappi/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

distutils_enable_tests unittest

PATCHES=(
	"${FILESDIR}/yappi-1.2.5-warnings.patch"
)

python_test() {
	local -x PYTHONPATH=tests
	eunittest
}
