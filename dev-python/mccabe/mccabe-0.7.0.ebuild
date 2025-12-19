# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="flake8 plugin: McCabe complexity checker"
HOMEPAGE="
	https://github.com/PyCQA/mccabe/
	https://pypi.org/project/mccabe/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	dev-python/flake8[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-fix-tests-without-hypothesmith.patch"
)

distutils_enable_tests pytest
