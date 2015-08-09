# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

MY_PN="SilverCity"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A lexical analyser for many languages"
HOMEPAGE="http://silvercity.sourceforge.net/"
SRC_URI="mirror://sourceforge/silvercity/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# Fix line endings.
	find -type f -exec sed -e 's/\r$//' -i {} + || die "sed failed"

	# Fix permissions.
	chmod -x CSS/default.css || die "chmod failed"

	# Fix shebang.
	sed -e 's:#!/usr/home/sweetapp/bin/python:#!/usr/bin/env python:' \
		-i PySilverCity/Scripts/cgi-styler-form.py || die "sed failed"

	distutils-r1_python_prepare_all
}
