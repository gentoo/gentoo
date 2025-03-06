# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A package containing multiple implementations of Ordered Set"
HOMEPAGE="
	https://github.com/seperman/orderly-set/
	https://pypi.org/project/orderly-set/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unconditional mypy dep for a test that is not even run
	# https://github.com/seperman/orderly-set/pull/5
	sed -i -e '/mypy\.api/d' tests/*.py || die
}
