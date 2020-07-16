# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Component-based Software-defined Networking Framework"
HOMEPAGE="http://osrg.github.io/ryu/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]"
RDEPEND=""

python_install_all() {
	distutils-r1_python_install_all
	mv "${D}"/usr/etc "${D}"/etc
}
