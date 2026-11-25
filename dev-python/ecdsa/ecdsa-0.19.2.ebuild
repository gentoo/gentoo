# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="ECDSA cryptographic signature library in pure Python"
HOMEPAGE="
	https://github.com/tlsfuzzer/python-ecdsa/
	https://pypi.org/project/ecdsa/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/gmpy2[${PYTHON_USEDEP}]
	' 'python*')
	dev-python/six[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( hypothesis )
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/tlsfuzzer/python-ecdsa/commit/f8e0f3a0035b44fa2541e2c447ed1599f220c4b5
	"${FILESDIR}/${P}-py315.patch"
)
