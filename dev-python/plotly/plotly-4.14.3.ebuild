# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Browser-based graphing library for Python"
HOMEPAGE="https://plot.ly/python/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/retrying[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all

	mkdir -p "${ED}"/etc/ || die
	mv "${ED}"/usr/etc/jupyter "${ED}"/etc/ || die
	rmdir "${ED}"/usr/etc || die
}
