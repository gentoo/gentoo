# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python binding to the Networking and Cryptography (NaCl) library"
HOMEPAGE="https://github.com/pyca/pynacl/ https://pypi.org/project/PyNaCl/"
SRC_URI="https://github.com/pyca/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.4.1[${PYTHON_USEDEP}]
	dev-libs/libsodium:0/23
"
BDEPEND="${RDEPEND}
	test? ( >=dev-python/hypothesis-3.27.0[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

src_prepare() {
	# For not using the bundled libsodium
	export SODIUM_INSTALL=system
	distutils-r1_src_prepare
}
