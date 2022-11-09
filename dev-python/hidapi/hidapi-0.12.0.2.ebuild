# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A Cython interface to HIDAPI library"
HOMEPAGE="https://github.com/trezor/cython-hidapi"
MY_PV=$(ver_rs 3 .post)
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${MY_PV}.tar.gz"

LICENSE="|| ( BSD GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND=">=dev-libs/hidapi-$(ver_cut 1-3)"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

S="${WORKDIR}/${PN}-${MY_PV}"

python_configure_all() {
	DISTUTILS_ARGS=( --with-system-hidapi )
}

python_test() {
	epytest tests.py
}
