# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/keepassx/keepassx-0.1.0.ebuild,v 1.1 2015/06/15 22:19:27 mrueg Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="Python API and CLI for KeePassX"
HOMEPAGE="https://github.com/jamesls/python-keepassx https://pypi.python.org/pypi/keepassx"
SRC_URI="https://github.com/jamesls/python-keepassx/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

S=${WORKDIR}/python-${P}

RDEPEND="
	dev-python/pycrypto[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
python_test() {
	py.test tests || die
}
