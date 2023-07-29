# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Oslo test framework"
HOMEPAGE="
	https://opendev.org/openstack/oslotest/
	https://github.com/openstack/oslotest/
	https://pypi.org/project/oslotest/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86 ~amd64-linux ~x86-linux"

BDEPEND="
	>=dev-python/pbr-1.8[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-py3.12-fix.patch"
)

distutils_enable_tests unittest

src_prepare() {
	sed -i -e '/subunit/d' requirements.txt || die
	distutils-r1_src_prepare
}
