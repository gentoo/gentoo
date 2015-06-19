# Copyright 2014-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pymysql/pymysql-0.6.3.ebuild,v 1.2 2015/02/16 16:21:24 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

MY_PN="PyMySQL"
DESCRIPTION="Pure-Python MySQL Driver"
HOMEPAGE="http://www.pymysql.org/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

S=${WORKDIR}/${MY_PN}-${P}

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# While tests exist, they require an unsecure server to run without manual config file
RESTRICT="test"

python_test() {
	${PYTHON} runtests.py || die
}
