# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="A Cython interface to HIDAPI library"
HOMEPAGE="https://github.com/trezor/cython-hidapi"

LICENSE="|| ( BSD GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND=">=dev-libs/hidapi-$(ver_cut 1-3)"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_configure_all() {
	DISTUTILS_ARGS=( --with-system-hidapi )
}

python_test() {
	epytest tests.py
}
