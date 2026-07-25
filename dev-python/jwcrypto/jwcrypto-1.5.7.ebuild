# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..15} )

inherit distutils-r1 pypi

DESCRIPTION="Implements JWK,JWS,JWE specifications using python-cryptography"
HOMEPAGE="
	https://github.com/latchset/jwcrypto/
	https://pypi.org/project/jwcrypto/
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	>=dev-python/cryptography-3.4[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install
	rm -r "${ED}/usr/share/doc/jwcrypto" || die
}
