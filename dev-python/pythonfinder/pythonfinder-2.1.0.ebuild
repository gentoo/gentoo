# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="PythonFinder: Cross Platform Search Tool for Finding Pythons"
HOMEPAGE="
	https://github.com/sarugaku/pythonfinder/
	https://pypi.org/project/pythonfinder/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv"

BDEPEND="
	test? (
		dev-python/click[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	epytest -o addopts=
}
