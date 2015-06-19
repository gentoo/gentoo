# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ijson/ijson-2.2.ebuild,v 1.1 2015/06/15 22:23:48 mrueg Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Iterative JSON parser with a Pythonic interface"
HOMEPAGE="https://github.com/isagalaev/ijson http://pypi.python.org/pypi/ijson/"
SRC_URI="https://github.com/isagalaev/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/yajl"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	${EPYTHON} tests.py || die
}
