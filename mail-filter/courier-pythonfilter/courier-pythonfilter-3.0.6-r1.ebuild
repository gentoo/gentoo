# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9,10,11,12,13} )
PYPI_NO_NORMALIZE=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Python filtering architecture for the Courier MTA"
HOMEPAGE="https://pypi.org/project/courier-pythonfilter/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="mail-mta/courier"

python_install() {
	distutils-r1_python_install
	rm -rf "${D}$(python_get_sitedir)/etc" || die
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc
	doins pythonfilter.conf pythonfilter-modules.conf
}
