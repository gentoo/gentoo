# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_6}  )

inherit distutils-r1

DESCRIPTION="Test Configuration plugin for nosetests"
HOMEPAGE="https://bitbucket.org/jnoller/nose-testconfig"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="examples"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="dev-python/nose"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DOCS=( docs/index.txt )

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
