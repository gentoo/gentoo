# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="Unified Interface to the Cloud - python support libs"
HOMEPAGE="https://libcloud.apache.org/"
SRC_URI="mirror://apache/${PN}/apache-${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples test"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/lockfile[${PYTHON_USEDEP}]
	)"

# Known test failures
RESTRICT="test"

S="${WORKDIR}/apache-${P}"

python_prepare_all() {
	if use examples; then
		mkdir examples || die
		mv example_*.py examples || die
	fi
	distutils-r1_python_prepare_all
}

src_test() {
	cp libcloud/test/secrets.py-dist libcloud/test/secrets.py || die
	distutils-r1_src_test
}

python_test() {
	esetup.py test
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
