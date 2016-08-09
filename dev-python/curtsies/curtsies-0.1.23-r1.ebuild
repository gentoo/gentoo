# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1

DESCRIPTION="Curses-like terminal wrapper, with colored strings"
HOMEPAGE="https://github.com/thomasballinger/curtsies"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/blessings-1.5[${PYTHON_USEDEP}]
	>=dev-python/wcwidth-0.1.4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pyte[${PYTHON_USEDEP}]
	)
"

python_test() {
	nosetests --verbose tests || die
}
