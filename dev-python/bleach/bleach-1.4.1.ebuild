# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/bleach/bleach-1.4.1.ebuild,v 1.3 2015/03/08 23:40:39 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="an easy whitelist-based HTML-sanitizing tool"
HOMEPAGE="https://github.com/jsocol/bleach https://pypi.python.org/pypi/bleach"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=dev-python/html5lib-0.999[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/nose-1.3[${PYTHON_USEDEP}] )
"

python_test() {
	esetup.py test
}
