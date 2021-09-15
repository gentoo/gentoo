# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_P="NetLink-${PV}"

DESCRIPTION="Pure-Python client for the Linux NetLink interface"
HOMEPAGE="https://pypi.org/project/NetLink/ https://xmine128.tk/Software/Python/netlink/docs/"
SRC_URI="mirror://pypi/${MY_P:0:1}/NetLink/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!dev-libs/libnl[python(-)]"

python_prepare_all() {
	distutils-r1_python_prepare_all
	# setuptools-markdown is not needed.
	sed -e "s:'setuptools-markdown'::" -i setup.py || die
}
