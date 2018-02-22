# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6})

inherit distutils-r1

DESCRIPTION="Python binding to the Networking and Cryptography (NaCl) library"
HOMEPAGE="https://github.com/pyca/pynacl/ https://pypi.python.org/pypi/PyNaCl/"
SRC_URI="https://github.com/pyca/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86 ~amd64-fbsd"
IUSE="test"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.4.1[${PYTHON_USEDEP}]
	dev-libs/libsodium:0/23
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/pytest-2.6.4[${PYTHON_USEDEP}] )
"

src_prepare() {
	# For not using the bundled libsodium
	export SODIUM_INSTALL=system
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v || die "Tests failed under ${EPYTHON}"
}
