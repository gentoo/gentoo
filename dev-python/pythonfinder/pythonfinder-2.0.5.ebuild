# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="PythonFinder: Cross Platform Search Tool for Finding Pythons"
HOMEPAGE="
	https://github.com/sarugaku/pythonfinder
	https://pypi.org/project/pythonfinder/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

PATCHES=(
	"${FILESDIR}/2.0.5-fix-import-cached-property.patch"
)

RDEPEND="
	<dev-python/pydantic-2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
