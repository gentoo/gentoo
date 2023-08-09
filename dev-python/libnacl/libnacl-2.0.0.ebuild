# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python ctypes wrapper for libsodium"
HOMEPAGE="
	https://libnacl.readthedocs.io/
	https://github.com/saltstack/libnacl/
	https://pypi.org/project/libnacl/
"
SRC_URI="
	https://github.com/saltstack/libnacl/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	dev-libs/libsodium
"
BDEPEND="
	${RDEPEND}
"

distutils_enable_tests unittest

python_test() {
	eunittest -p 'test_*.py' tests/ ||
		die "Tests failed with ${EPYTHON}"
}
