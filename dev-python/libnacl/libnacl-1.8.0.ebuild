# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python ctypes wrapper for libsodium"
HOMEPAGE="
	https://libnacl.readthedocs.io/
	https://github.com/saltstack/libnacl/
	https://pypi.org/project/libnacl/
"
# forked because upstream didn't push the tag for almost a year now
SRC_URI="
	https://github.com/mgorny/libnacl/archive/v${PV}.tar.gz
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
