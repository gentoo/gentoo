# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )

inherit distutils-r1

MY_PN="${PN}4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pythonic idioms for iterating, searching, and modifying an HTML/XML parse tree"
HOMEPAGE="https://www.crummy.com/software/BeautifulSoup/bs4/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

# html5lib is optional however hard coding since its use is actively discouraged in the devmanual
RDEPEND="
	dev-python/soupsieve[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/html5lib[${PYTHON_USEDEP}]' python2_7 pypy)
	$(python_gen_cond_dep 'dev-python/lxml[${PYTHON_USEDEP}]' python2_7 'python3*')
"
BDEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

distutils_enable_tests nose
distutils_enable_sphinx doc/source --no-autodoc

python_test() {
	nosetests --verbose -w "${BUILD_DIR}"/lib || die "Tests fail with ${EPYTHON}"
}
