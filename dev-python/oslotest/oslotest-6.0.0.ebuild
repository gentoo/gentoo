# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pbr
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Oslo test framework"
HOMEPAGE="
	https://opendev.org/openstack/oslotest/
	https://github.com/openstack/oslotest/
	https://pypi.org/project/oslotest/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 x86"

RDEPEND="
	>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/testtools-2.2.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_prepare() {
	sed -i -e '/subunit/d' requirements.txt || die
	distutils-r1_src_prepare
}
