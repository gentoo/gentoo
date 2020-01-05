# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PN="pypillowfight"

DESCRIPTION="Small library containing various image processing algorithms"
HOMEPAGE="https://github.com/openpaperwork/libpillowfight"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${MY_PN}-${PV}

python_prepare_all() {
	sed -e "/'nose>=1.0'/d" -i setup.py || die
	distutils-r1_python_prepare_all
}
