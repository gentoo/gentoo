# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_PN="DBUtils"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Database connections for multi-threaded environments"
HOMEPAGE="
	https://webwareforpython.github.io/DBUtils/
	https://github.com/WebwareForPython/DBUtils/
	https://pypi.org/project/DBUtils/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="OSL-2.0"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests unittest

python_install_all() {
	dodoc docs/*.rst
	rm docs/*.rst || die
	local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
