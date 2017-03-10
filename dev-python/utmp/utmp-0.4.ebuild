# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{3_4,3_5} )

inherit distutils-r1

DESCRIPTION="utmp/wtmp reader"
HOMEPAGE="https://pypi.python.org/pypi/utmp http://srcco.de/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	!sys-apps/utempter"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed "s:'flake8'::g" -i setup.py || die
	distutils-r1_python_prepare_all
}
