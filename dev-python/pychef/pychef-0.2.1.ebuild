# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Nova API"
HOMEPAGE="https://github.com/coderanger/pychef"
SRC_URI="mirror://pypi/P/PyChef/PyChef-${PV}.tar.gz"
S="${WORKDIR}/PyChef-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/versiontools[${PYTHON_USEDEP}]
		test? ( dev-python/mock[${PYTHON_USEDEP}] )"
RDEPEND=""

python_test() {
	nosetests || die
}
