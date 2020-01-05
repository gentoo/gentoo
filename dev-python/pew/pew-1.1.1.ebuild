# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1

DESCRIPTION="tool to manage multiple virtualenvs written in pure python"
HOMEPAGE="
	https://github.com/berdario/pew
	https://pypi.org/project/pew/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-python/pythonz-bd-1.11.2[${PYTHON_USEDEP}]
	>=dev-python/setuptools-17.1[${PYTHON_USEDEP}]
	>=dev-python/shutilwhich-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-1.11.6[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-clone-0.2.5[${PYTHON_USEDEP}]"
