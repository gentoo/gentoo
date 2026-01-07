# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} python3_14t )

inherit distutils-r1

DESCRIPTION="Python binding to the Networking and Cryptography (NaCl) library"
HOMEPAGE="
	https://github.com/pyca/pynacl/
	https://pypi.org/project/PyNaCl/
"
SRC_URI="
	https://github.com/pyca/pynacl/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

DEPEND="
	dev-libs/libsodium:=
"
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.4.1[${PYTHON_USEDEP}]
	' 'python*')
"
BDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.4.1[${PYTHON_USEDEP}]
	' 'python*')
"

EPYTEST_PLUGINS=( hypothesis )
distutils_enable_tests pytest

src_compile() {
	# For not using the bundled libsodium
	local -x SODIUM_INSTALL=system
	distutils-r1_src_compile
}
