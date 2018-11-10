# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="A utility to report core memory usage per program"
HOMEPAGE="https://github.com/pixelb/${PN}"
SRC_URI="https://github.com/pixelb/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_install() {
	distutils-r1_python_install --install-scripts="${EPREFIX}/usr/sbin"
}

python_install_all() {
	distutils-r1_python_install_all
	doman ${PN}.1
}
