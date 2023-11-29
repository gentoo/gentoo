# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="JOSE protocol implementation in Python"
HOMEPAGE="
	https://github.com/certbot/josepy/
	https://pypi.org/project/josepy/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/cryptography-1.5[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# I haven't seen a single switch to poetry without major bugs yet...
	sed -i -e 's:^include:exclude:' pyproject.toml || die

	distutils-r1_src_prepare
}
