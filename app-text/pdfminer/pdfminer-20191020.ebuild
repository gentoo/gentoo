# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python tool for extracting information from PDF documents"
HOMEPAGE="https://euske.github.io/pdfminer/ https://pypi.org/project/pdfminer/"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/pycryptodome[${PYTHON_USEDEP}]"

python_compile_all() {
	use examples && emake -C samples all
}

python_test() {
	emake test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	use examples && dodoc -r samples
	distutils-r1_python_install_all
}
