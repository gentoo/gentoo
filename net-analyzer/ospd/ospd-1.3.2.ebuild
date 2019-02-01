# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Openvas OSP (Open Scanner Protocol)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="https://github.com/greenbone/ospd/archive/v1.3.2.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-lang/python-3.6.5:3.6
	dev-python/setuptools
	>=dev-python/paramiko-2.4.2
	dev-python/defusedxml
	dev-python/lxml
	>=net-analyzer/openvas-libraries-9.0.3
"

RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile
}

python_install_all() {
	distutils-r1_python_install_all
}
