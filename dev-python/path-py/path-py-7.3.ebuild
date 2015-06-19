# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/path-py/path-py-7.3.ebuild,v 1.1 2015/04/20 08:22:32 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

MY_P="path.py-${PV}"

DESCRIPTION="A module wrapper for os.path"
HOMEPAGE="http://pythonhosted.org/path.py https://pypi.python.org/pypi/path.py https://github.com/jaraco/path.py"
SRC_URI="mirror://pypi/p/path.py/${MY_P}.zip"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_test() {
	py.test || die "Testing failed with ${EPYTHON}"
}
