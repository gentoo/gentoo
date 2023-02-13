# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Documenting CLI programs"
HOMEPAGE="https://github.com/sphinx-contrib/autoprogram"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc \
	dev-python/sphinxcontrib-websupport \
	dev-python/sphinxcontrib-serializinghtml

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
