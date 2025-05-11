# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="HTTP/2 State-Machine based protocol implementation"
HOMEPAGE="
	https://python-hyper.org/projects/h2/en/stable/
	https://github.com/python-hyper/h2/
	https://pypi.org/project/h2/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/hyperframe-6.1[${PYTHON_USEDEP}]
	<dev-python/hyperframe-7[${PYTHON_USEDEP}]
	>=dev-python/hpack-4.1[${PYTHON_USEDEP}]
	<dev-python/hpack-5[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x CI=1
	epytest -p hypothesis
}
