# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="threads(+)"

MY_P=python-${P}
MY_PN=python-${PN}

inherit distutils-r1

DESCRIPTION="Library for using the Mercurial Command Server from Python"
HOMEPAGE="http://mercurial.selenic.com/"
SRC_URI="mirror://pypi/p/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-vcs/mercurial-2.4.2"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${MY_P}

python_test() {
	if ! ${PYTHON} test.py; then
		die "Tests failed under ${EPYTHON}"
	fi
}

python_install_all() {
	docinto examples
	dodoc -r examples/stats.py
	docompress -x /usr/share/doc/${PF}/examples

	distutils-r1_python_install_all
}
