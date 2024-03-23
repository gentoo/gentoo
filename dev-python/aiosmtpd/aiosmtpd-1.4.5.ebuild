# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Reimplementation of the Python stdlib smtpd.py based on asyncio"
HOMEPAGE="
	https://aiosmtpd.aio-libs.org/
	https://github.com/aio-libs/aiosmtpd
	https://pypi.org/project/aiosmtpd/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=dev-python/atpublic-4.0[${PYTHON_USEDEP}]
	>=dev-python/attrs-23.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( >=dev-python/pytest-mock-3.12.0[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e '/--cov=/d' pytest.ini || die

	distutils-r1_python_prepare_all
}
