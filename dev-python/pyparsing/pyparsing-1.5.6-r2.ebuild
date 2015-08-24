# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

DESCRIPTION="pyparsing is an easy-to-use Python module for text parsing"
HOMEPAGE="http://pyparsing.wikispaces.com/ https://pypi.python.org/pypi/pyparsing"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

# Build system copies the module from py2/py3 version to the regular
# name before installing.
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# resorted to sed, fixed in June upstream, bug ID: 3381439.
	# See Bug #443836.
	sed -e "s/26 June 2011 10:53/16 June 2012 03:08/" \
		-e 's:exc.__traceback__:pe.__traceback__:' \
		-i pyparsing_py3.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	local HTML_DOCS=( HowToUsePyparsing.html )

	distutils-r1_python_install_all

	insinto /usr/share/doc/${PF}

	if use doc; then
		dohtml -r htmldoc/*
		doins docs/*.pdf
	fi

	if use examples; then
		doins -r examples
	fi
}
