# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python{3_4,3_5,3_6} )
inherit distutils-r1

DESCRIPTION="Jinja2 Extension for Dates and Times"
HOMEPAGE="https://github.com/hackebrot/jinja2-time"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/arrow[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]"
DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/freezegun[${PYTHON_USEDEP}]
	${RDEPEND} )"

python_test() {
	py.test || die
}
