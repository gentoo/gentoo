# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Extends nose.plugins.cover to add Cobertura-style XML reports"
HOMEPAGE="https://github.com/cmheisel/nose-xcover/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="
	dev-python/nose[${PYTHON_USEDEP}]
	>=dev-python/coverage-3.4[${PYTHON_USEDEP}]"

python_test() {
	nosetests -v nosexcover/tests.py || die
}
