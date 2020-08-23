# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

MY_PN="${PN/py/py3}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Python DNS (Domain Name System) library"
HOMEPAGE="https://launchpad.net/py3dns"
SRC_URI="https://launchpad.net/${MY_PN}/trunk/${PV}/+download/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="CNRI"
SLOT="3"
KEYWORDS="amd64 hppa ~ia64 ~ppc sparc x86"
IUSE="examples"

# Tests require network access
RESTRICT="test"

distutils_enable_tests unittest

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r tests/. tools/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
