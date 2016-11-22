# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Simplifies the usage of decorators for the average programmer"
HOMEPAGE="https://pypi.python.org/pypi/decorator https://github.com/micheles/decorator"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( docs/README.rst )

python_test() {
	"${PYTHON}" src/tests/test.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && dodoc documentation.pdf
	distutils-r1_python_install_all
}
