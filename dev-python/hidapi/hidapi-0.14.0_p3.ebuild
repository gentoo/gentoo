# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A Cython interface to HIDAPI library"
HOMEPAGE="
	https://github.com/trezor/cython-hidapi/
	https://pypi.org/project/hidapi/
"

LICENSE="|| ( BSD GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="
	>=dev-libs/hidapi-$(ver_cut 1-3)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	virtual/pkgconfig
"

distutils_enable_tests pytest

python_configure_all() {
	DISTUTILS_ARGS=(
		--with-system-hidapi
	)
}

python_test() {
	epytest tests.py
}
