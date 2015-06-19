# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/itsdangerous/itsdangerous-0.23.ebuild,v 1.9 2015/05/15 12:49:40 blueness Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3} pypy )

inherit distutils-r1

DESCRIPTION="Various helpers to pass trusted data to untrusted environments and back"
HOMEPAGE="http://pythonhosted.org/itsdangerous/ http://pypi.python.org/pypi/itsdangerous"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
# Required for running tests.py
DISTUTILS_IN_SOURCE_BUILD=1

python_test() {
	if python_is_python3; then
		2to3 -f unicode -nw --no-diffs tests.py
	fi
	"${PYTHON}" tests.py || die "Tests failed under ${EPYTHON}"
}
