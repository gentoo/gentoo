# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1

MY_PN="PyMySQL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pure-Python MySQL Driver"
HOMEPAGE="http://www.pymysql.org/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

S=${WORKDIR}/${MY_P}

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# While tests exist, they require an unsecure server to run without manual config file
RESTRICT="test"

python_test() {
	${PYTHON} runtests.py || die
}
