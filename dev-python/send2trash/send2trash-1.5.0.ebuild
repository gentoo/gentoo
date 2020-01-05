# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1

MY_PN="Send2Trash"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Sends files to the Trash (or Recycle Bin)"
HOMEPAGE="
	https://pypi.org/project/Send2Trash/
	https://github.com/hsoft/send2trash"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}/${P}-fix-broken-tests-on-py2.patch"
)

python_test() {
	${EPYTHON} setup.py test
}
