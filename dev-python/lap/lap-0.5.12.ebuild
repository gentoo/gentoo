# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Linear Assignment Problem solver (LAPJV/LAPMOD)"
HOMEPAGE="
	https://github.com/gatagat/lap
	https://pypi.org/project/lap/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.21.6[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.23.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# Don't install tests and keep them in a separate location
	# https://projects.gentoo.org/python/guide/test.html#importerrors-for-c-extensions
	mv lap/tests tests || die
	sed -e '/tests_package =/d' \
		-e '/packages =/ { s/, tests_package// }' \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	rm -rf lap || die
	epytest
}
