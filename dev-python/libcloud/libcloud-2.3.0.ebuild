# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="Unified Interface to the Cloud - python support libs"
HOMEPAGE="https://libcloud.apache.org/"
SRC_URI="mirror://apache/${PN}/apache-${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/lockfile[${PYTHON_USEDEP}]
		 $(python_gen_cond_dep 'dev-python/backports-ssl-match-hostname[${PYTHON_USEDEP}]' python{2_7,3_4} pypy)
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
