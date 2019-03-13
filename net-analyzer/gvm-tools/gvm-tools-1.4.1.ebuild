# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6} )
inherit distutils-r1

DESCRIPTION="A remote security scanner for Linux (OpenVAS-cli)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="https://github.com/greenbone/gvm-tools/archive/v1.4.1.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/pythondialog:0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=net-analyzer/openvas-manager-7.0.3
	!net-analyzer/openvas-cli"

DEPEND="
	${RDEPEND}
	>=net-analyzer/openvas-libraries-9.0.3"

src_prepare() {
	distutils-r1_python_prepare_all
	# Exlude tests & correct FHS/Gentoo policy paths
	sed -i "s/packages=find_packages(),.*/packages=find_packages(exclude=['tests*', 'docs']),/" "$S"/setup.py || die
	sed -i -e "s*''*'/usr/share/doc/${P}'*g" "$S"/setup.py || die
}
