# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="A remote security scanner for Linux (OpenVAS-cli)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="https://github.com/greenbone/gvm-tools/archive/v1.4.1.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-python/lxml-4.2.5
	>=dev-python/paramiko-2.4.2
	>=dev-python/defusedxml-0.5.0
	dev-python/pythondialog:0
	>=net-analyzer/openvas-libraries-9.0.3
"

RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

src_prepare() {
	distutils-r1_python_prepare_all
	sed -i "s/packages=find_packages(),.*/packages=find_packages(exclude=['tests*', 'docs']),/" "$S"/setup.py || die
}

src_configure() {
	distutils-r1_src_configure
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}
