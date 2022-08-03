# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Yet Another Python Profiler"
HOMEPAGE="
	https://pypi.org/project/yappi/
	https://github.com/sumerc/yappi/
"
SRC_URI="
	https://github.com/sumerc/yappi/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

BDEPEND="
	test? (
		dev-python/gevent[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

PATCHES=(
	"${FILESDIR}/yappi-1.2.5-warnings.patch"
)

python_test() {
	local -x PYTHONPATH=tests
	eunittest
}
