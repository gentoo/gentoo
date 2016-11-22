# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

MY_PN="Markups"
MY_P=${MY_PN}-${PV}

DESCRIPTION="A wrapper around various text markups"
HOMEPAGE="
	http://pythonhosted.org/Markups/
	https://github.com/retext-project/pymarkups
	https://pypi.python.org/pypi/Markups"
SRC_URI="mirror://pypi/M/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"/${MY_P}

DEPEND="dev-python/markdown[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_test() {
	${EPYTHON} -m unittest discover -s tests -v || die
}
