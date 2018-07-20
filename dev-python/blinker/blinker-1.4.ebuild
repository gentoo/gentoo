# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Fast, simple object-to-object and broadcast signaling"
HOMEPAGE="https://pythonhosted.org/blinker/ https://pypi.org/project/blinker/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

DEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( docs/html/. )
	distutils-r1_python_install_all
}
