# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python{2_7,3_5,3_6,3_7})
inherit distutils-r1

DESCRIPTION="Automated Reasoning Engine and Flow Based Programming Framework"
HOMEPAGE="https://github.com/ioflo/ioflo/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -e 's:"setuptools_git[^"]*",::' -i setup.py || die
	distutils-r1_python_prepare_all
}
