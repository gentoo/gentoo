# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

MY_PN=${PN}4
MY_P=${MY_PN}-${PV}

DESCRIPTION="Provides pythonic idioms for iterating, searching, and modifying an HTML/XML parse tree"
HOMEPAGE="https://bugs.launchpad.net/beautifulsoup/
	http://pypi.python.org/pypi/beautifulsoup4"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

IUSE="doc test"

# html5lib is optional however hard coding since its use is actively discouraged in the devmanual
RDEPEND="$(python_gen_cond_dep 'dev-python/html5lib[${PYTHON_USEDEP}]' python2_7 pypy)
		$(python_gen_cond_dep 'dev-python/lxml[${PYTHON_USEDEP}]' python2_7 'python3*')"
DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		!dev-python/chardet[${PYTHON_USEDEP}] )"
# See https://bugs.launchpad.net/beautifulsoup/+bug/1471359 to explain need for blocker

S=${WORKDIR}/${MY_P}

python_compile_all() {
	if use doc; then
		emake -C doc html
	fi
}

python_test() {
	nosetests -w "${BUILD_DIR}"/lib || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=doc/build/html/.
	distutils-r1_python_install_all
}
