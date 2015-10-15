# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )

inherit distutils-r1

DESCRIPTION="pyparsing is an easy-to-use Python module for text parsing"
HOMEPAGE="http://pyparsing.wikispaces.com/ https://pypi.python.org/pypi/pyparsing"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples"

RDEPEND="!dev-python/pyparsing:py2 !dev-python/pyparsing:py3"

# no contained in the tarball
RESTRICT=test

python_install_all() {
	local HTML_DOCS=( HowToUsePyparsing.html )
	if use doc; then
		HTML_DOCS+=( htmldoc/. )
		dodoc docs/*.pdf
	fi
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}

python_test() {
	${PYTHON} unitTests.py || die
}
