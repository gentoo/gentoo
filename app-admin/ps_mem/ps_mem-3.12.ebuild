# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )
inherit distutils-r1

DESCRIPTION="A utility to report core memory usage per program"
HOMEPAGE="https://github.com/pixelb/${PN}"
SRC_URI="https://github.com/pixelb/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${PYTHON_DEPS}"

python_install() {
	distutils-r1_python_install --install-scripts="/usr/sbin"
}

src_install() {
	distutils-r1_src_install
	doman ${PN}.1
}
