# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="Unified Interface to the Cloud - python support libs"
HOMEPAGE="https://libcloud.apache.org/"
SRC_URI="mirror://apache/${PN}/apache-${P}.tar.bz2"
S="${WORKDIR}/apache-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="examples"

RDEPEND=">=dev-python/requests-2.5.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

BDEPEND+="
	test? (
		>=dev-python/cryptography-2.6.1[${PYTHON_USEDEP}]
		dev-python/lockfile[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	if use examples; then
		mkdir examples || die
		mv example_*.py examples || die
	fi

	# needed for tests
	cp libcloud/test/secrets.py-dist libcloud/test/secrets.py || die

	# Needs network access
	sed -i -e "s/test_list_nodes_invalid_region(self):/_&/" \
		libcloud/test/compute/test_ovh.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
