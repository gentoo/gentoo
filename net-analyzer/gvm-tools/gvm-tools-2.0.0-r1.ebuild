# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Remote control for Greenbone Vulnerability Manager, previously named openvas-cli"
HOMEPAGE="https://www.greenbone.net/en/"
SRC_URI="https://github.com/greenbone/gvm-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	net-analyzer/python-gvm[${PYTHON_USEDEP}]
	!net-analyzer/openvas-cli
	!net-analyzer/openvas-tools"

DEPEND="
	${RDEPEND}"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare
	# Exlude tests & correct FHS/Gentoo policy paths
	sed -i "s/packages=find_packages(),.*/packages=find_packages(exclude=['tests*', 'docs']),/" setup.py || die
	sed -i -e "s*''*'/usr/share/doc/${P}'*g" setup.py || die

	# Fixing tests
	# Use correct socket path
	sed -i "s/\/usr\/local\/var\/run\/gvmd.sock/\/var\/run\/gvmd.sock/g" tests/test_parser.py || die
	# ignore help formating
	sed -i "s/class HelpFormatting/@unittest.skip('ignoring help formatting')\nclass HelpFormatting/g" tests/test_parser.py || die
}
