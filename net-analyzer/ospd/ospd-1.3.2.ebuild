# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )
inherit distutils-r1

DESCRIPTION="Openvas OSP (Open Scanner Protocol)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="https://github.com/greenbone/ospd/archive/v1.3.2.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="extras"

RDEPEND="
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	>=net-analyzer/greenbone-security-assistant-7.0.3"

DEPEND="
	${RDEPEND}"

python_compile() {
	if use extras; then
		bash "${S}"/doc/generate || die
		HTML_DOCS=( "${S}"/doc/. )
	fi
	distutils-r1_python_compile
}
