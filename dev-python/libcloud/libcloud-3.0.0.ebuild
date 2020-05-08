# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="Unified Interface to the Cloud - python support libs"
HOMEPAGE="https://libcloud.apache.org/"
SRC_URI="mirror://apache/${PN}/apache-${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="examples test"

RDEPEND="
	>=dev-python/requests-2.5.0[${PYTHON_USEDEP}]

"
BDEPEND="${RDEPEND}
	test? (
		dev-python/lockfile[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		>=dev-python/cryptography-2.6.1[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/apache-${P}"

distutils_enable_tests pytest

python_prepare_all() {
	if use examples; then
		mkdir examples || die
		mv example_*.py examples || die
	fi

	# needed for tests
	cp libcloud/test/secrets.py-dist libcloud/test/secrets.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
