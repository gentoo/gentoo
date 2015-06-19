# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/feedparser/feedparser-5.1.3.ebuild,v 1.1 2012/12/09 21:45:45 rafaelmartins Exp $

EAPI="4"
SUPPORT_PYTHON_ABIS="1"
PYTHON_TESTS_RESTRICTED_ABIS="*-jython"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*"

inherit distutils eutils

DESCRIPTION="Parse RSS and Atom feeds in Python"
HOMEPAGE="http://code.google.com/p/feedparser/ http://pypi.python.org/pypi/feedparser"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

# sgmllib is licensed under PSF-2.
LICENSE="BSD-2 PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""

DISTUTILS_USE_SEPARATE_SOURCE_DIRECTORIES="1"
PYTHON_MODNAME="feedparser.py _feedparser_sgmllib.py"

src_prepare() {
	mv feedparser/sgmllib3.py feedparser/_feedparser_sgmllib.py || die "Renaming sgmllib3.py failed"
	epatch "${FILESDIR}/${PN}-5.1-sgmllib.patch"

	sed -e "/import feedparser/isys.path.insert(0, '../build/lib')" -i feedparser/feedparsertest.py

	distutils_src_prepare

	preparation() {
		if [[ "${PYTHON_ABI}" == 3.* ]]; then
			2to3-${PYTHON_ABI} -nw --no-diffs feedparser/feedparsertest.py
		else
			# Avoid SyntaxErrors with Python 2.
			echo "raise ImportError" > feedparser/_feedparser_sgmllib.py
		fi
	}
	python_execute_function -s preparation
}

src_test() {
	testing() {
		cd feedparser || return 1
		"$(PYTHON)" feedparsertest.py
	}
	python_execute_function -s testing
}
