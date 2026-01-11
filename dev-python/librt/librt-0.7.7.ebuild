# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/mypyc/librt
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Mypyc runtime library"
HOMEPAGE="
	https://github.com/mypyc/librt/
	https://pypi.org/project/librt/
"

LICENSE="MIT PSF-2.4"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390"

BDEPEND="
	test? (
		dev-python/mypy-extensions[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_compile() {
	# setuptools is broken for C extensions, bug #907718, bug #967476 etc.
	distutils-r1_python_compile -j1
}

python_test() {
	rm -rf librt || die
	epytest smoke_tests.py
}
