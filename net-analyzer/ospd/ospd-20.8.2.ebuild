# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Base class for scanner wrappers, communication protocol for GVM"
HOMEPAGE="https://www.greenbone.net/en/ https://github.com/greenbone/ospd/"
SRC_URI="https://github.com/greenbone/ospd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="AGPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE="extras"

RDEPEND="
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/deprecated[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]"

DEPEND="
	${RDEPEND}"

distutils_enable_tests unittest

src_prepare() {
	default
	#QA-Fix: do not install test subpackages
	sed -i "s/tests']/tests*']/g" setup.py || die
}

python_compile() {
	if use extras; then
		bash "${S}"/doc/generate || die
		HTML_DOCS=( "${S}"/doc/. )
	fi
	distutils-r1_python_compile
}
