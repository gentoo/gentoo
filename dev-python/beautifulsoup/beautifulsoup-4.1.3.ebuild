# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/beautifulsoup/beautifulsoup-4.1.3.ebuild,v 1.9 2012/12/27 10:57:06 armin76 Exp $

EAPI="4"

PYTHON_DEPEND="*:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5"
PYTHON_TESTS_RESTRICTED_ABIS="*-pypy-*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

MY_PN="${PN}4"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Provides pythonic idioms for iterating, searching, and modifying an HTML/XML parse tree"
HOMEPAGE="http://www.crummy.com/software/BeautifulSoup/
	http://pypi.python.org/pypi/beautifulsoup4"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc test"

DEPEND="doc? ( dev-python/sphinx )
	test? ( dev-python/lxml )"
RDEPEND=""

PYTHON_MODNAME="bs4"
S="${WORKDIR}/${MY_P}"

src_compile() {
	distutils_src_compile
	if use doc; then
		emake -C doc html
	fi
}

src_test() {
	testing() {
		cd "build-${PYTHON_ABI}/lib"
		nosetests --verbosity="${PYTHON_TEST_VERBOSITY}"
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	if use doc; then
		dohtml -r doc/build/html/*
	fi
}
