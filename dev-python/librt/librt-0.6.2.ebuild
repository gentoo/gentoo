# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Mypyc runtime library"
HOMEPAGE="
	https://github.com/mypyc/librt/
	https://pypi.org/project/librt/
"
# no tests: https://github.com/mypyc/librt/issues/17
SRC_URI="
	https://github.com/mypyc/librt/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT PSF-2.4"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/mypy-extensions[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# this package is a mess
	# https://github.com/mypyc/librt/issues/17
	mv lib-rt/* . || die
}

python_test() {
	rm -rf librt || die
	epytest smoke_tests.py
}
