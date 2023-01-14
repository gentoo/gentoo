# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Pure-Python HPACK header compression"
HOMEPAGE="
	https://python-hyper.org/projects/hpack/en/latest/
	https://github.com/python-hyper/hpack/
	https://pypi.org/project/hpack/
"
SRC_URI="https://github.com/python-hyper/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

# dev-python/pytest-relaxed causes tests to fail
BDEPEND="
	test? (
		>=dev-python/hypothesis-3.4.2[${PYTHON_USEDEP}]
		!!dev-python/pytest-relaxed[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
