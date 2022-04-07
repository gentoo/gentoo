# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1 optfeature

DESCRIPTION="A minimal low-level HTTP client"
HOMEPAGE="https://www.encode.io/httpcore/"
SRC_URI="
	https://github.com/encode/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ppc ppc64 ~riscv sparc x86"

RDEPEND="
	=dev-python/anyio-3*[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	<dev-python/h11-0.14[${PYTHON_USEDEP}]
	<dev-python/h2-5[${PYTHON_USEDEP}]
	=dev-python/sniffio-1*[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/pytest-trio[${PYTHON_USEDEP}]
		dev-python/socksio[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/h11/s:,<0.13::' setup.py || die
	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "SOCKS support" dev-python/socksio
}
