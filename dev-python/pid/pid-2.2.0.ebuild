# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Pidfile featuring stale detection and file-locking"
HOMEPAGE="https://pypi.python.org/pypi/pid https://github.com/trbs/pid/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="dev-python/nose[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

python_test() {
	nosetests -v --with-coverage --cover-package=pid || die
}
