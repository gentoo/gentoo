# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7,8})

inherit distutils-r1

DESCRIPTION="Python binding to the Networking and Cryptography (NaCl) library"
HOMEPAGE="https://github.com/pyca/pynacl/ https://pypi.org/project/PyNaCl/"
SRC_URI="https://github.com/pyca/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.4.1[${PYTHON_USEDEP}]
	dev-libs/libsodium:0/23
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/hypothesis-3.27.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.2.1[${PYTHON_USEDEP}] )
"

PATCHES=( "${FILESDIR}/${P}-hypothesis-4.patch" )

src_prepare() {
	# For not using the bundled libsodium
	export SODIUM_INSTALL=system
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v || die "Tests failed under ${EPYTHON}"
}
