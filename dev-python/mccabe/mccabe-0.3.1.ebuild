# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mccabe/mccabe-0.3.1.ebuild,v 1.1 2015/06/20 15:44:38 mrueg Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="a plugin for flake8"
HOMEPAGE="https://github.com/flintwork/mccabe"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""
LICENSE="MIT"
SLOT="0"

RDEPEND=">=dev-python/pep8-1.4.3[${PYTHON_USEDEP}]
	dev-python/flake8[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	${EPYTHON} test_mccabe.py || die
}
