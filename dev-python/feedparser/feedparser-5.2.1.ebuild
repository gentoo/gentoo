# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )

inherit distutils-r1 eutils

DESCRIPTION="Parse RSS and Atom feeds in Python"
HOMEPAGE="https://github.com/kurtmckee/feedparser https://pypi.python.org/pypi/feedparser"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

# sgmllib is licensed under PSF-2.
LICENSE="BSD-2 PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

# Tests have issues with chardet installed, and are just kind of buggy.
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-sgmllib.patch"
)

python_prepare_all() {
	mv feedparser/sgmllib3.py feedparser/_feedparser_sgmllib.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	cp feedparser/feedparsertest.py "${BUILD_DIR}" || die
	ln -s "${S}/feedparser/tests" "${BUILD_DIR}/tests" || die
	cd "${BUILD_DIR}" || die
	if [[ ${EPYTHON} == python3* ]]; then
		2to3 --no-diffs -w -n feedparsertest.py || die
	fi
	"${PYTHON}" feedparsertest.py || die "Testing failed with ${EPYTHON}"
}
