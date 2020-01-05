# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

MY_PN="NetLink"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Pure-Python client for the Linux NetLink interface"
HOMEPAGE="https://pypi.org/project/NetLink/ https://xmine128.tk/Software/Python/netlink/docs/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="!dev-libs/libnl[python]"
S=${WORKDIR}/${MY_P}

python_prepare_all() {
	distutils-r1_python_prepare_all
	# setuptools-markdown is not needed.
	sed -e "s:'setuptools-markdown'::" -i setup.py || die
}
