# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Browser-based graphing library for Python"
HOMEPAGE="https://plotly.com/python/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
# The GitHub tarball contains the tests, but it excludes other things which have
# to be fetched with npm and therefore it does not work in the network-sandbox.

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/tenacity-6.2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.15.0[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all

	mkdir -p "${ED}"/etc/ || die
	mv "${ED}"/usr/etc/jupyter "${ED}"/etc/ || die
	rmdir "${ED}"/usr/etc || die
}
