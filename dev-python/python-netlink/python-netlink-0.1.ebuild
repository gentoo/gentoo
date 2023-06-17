# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYPI_NO_NORMALIZE=1
PYPI_PN="NetLink"

inherit distutils-r1 pypi

DESCRIPTION="Pure-Python client for the Linux NetLink interface"
HOMEPAGE="https://pypi.org/project/NetLink/ https://xmine128.tk/Software/Python/netlink/docs/"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!dev-libs/libnl[python(-)]"

python_prepare_all() {
	distutils-r1_python_prepare_all
	# setuptools-markdown is not needed.
	sed -e "s:'setuptools-markdown'::" -i setup.py || die
}
