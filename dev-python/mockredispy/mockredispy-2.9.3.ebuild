# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=(python2_7 python3_4)
inherit distutils-r1

DESCRIPTION="Mock for redis-py"
HOMEPAGE="https://github.com/locationlabs/mockredis"
SRC_URI="https://github.com/locationlabs/${PN%py}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="test" # Fail on python 2.7: https://github.com/locationlabs/mockredis/issues/105

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/nose[${PYTHON_USEDEP}]
	>=dev-python/redis-py-2.9.0[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN%py}-${PV}"

python_test() {
	esetup.py test
}
