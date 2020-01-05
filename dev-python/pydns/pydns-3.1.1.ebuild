# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 pypy3 )

inherit distutils-r1

MY_PN="${PN/py/py3}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Python DNS (Domain Name System) library"
HOMEPAGE="https://launchpad.net/py3dns"
SRC_URI="https://launchpad.net/${MY_PN}/trunk/${PV}/+download/${MY_P}.tar.gz"

LICENSE="CNRI"
SLOT="3"
KEYWORDS="amd64 hppa ~ia64 ~ppc ~sparc x86"
IUSE="examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# Tests require network access
RESTRICT="test"

S="${WORKDIR}/${MY_P}"

python_test() {
	"${EPYTHON}" -m unittest || die "tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r tests/. tools/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
