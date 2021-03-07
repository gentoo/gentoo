# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

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

LICENSE="OSL-2.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${MY_P}"

distutils_enable_tests nose

python_prepare_all() {
	#prevent tests from being installed
	#prevent docs being installed outside /usr/share
	sed -i -e "s/, 'DBUtils.Tests'//" \
		-e "/package_data=/d" \
		setup.py || die "sed failed"
	distutils-r1_python_prepare_all
}

python_install_all() {
	dodoc "${S}"/docs/*.rst
	rm "${S}"/docs/*.rst || die
	local HTML_DOCS=( "${S}"/docs/. )
	distutils-r1_python_install_all
}
