# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/beautifulsoup/beautifulsoup-4.3.2.ebuild,v 1.14 2015/01/02 12:22:09 ago Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

MY_PN=${PN}4
MY_P=${MY_PN}-${PV}

DESCRIPTION="Provides pythonic idioms for iterating, searching, and modifying an HTML/XML parse tree"
HOMEPAGE="http://www.crummy.com/software/BeautifulSoup/
	http://pypi.python.org/pypi/beautifulsoup4"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
# new html5 awaits keywording of html5lib in Bug 471002
IUSE="doc test"
# pending Bug 471002; html5? ( dev-python/html5lib[$(python_gen_usedep 'python{2_6,2_7}' pypy pypy2_0)] )

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}]
	dev-python/lxml[$(python_gen_usedep 'python{2_6,2_7}' 'python3*')] )"

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
