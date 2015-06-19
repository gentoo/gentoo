# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/silvercity/silvercity-0.9.7.ebuild,v 1.12 2014/08/10 18:33:45 slyfox Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

MY_PN="SilverCity"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A lexical analyser for many languages"
HOMEPAGE="http://silvercity.sourceforge.net/"
SRC_URI="mirror://sourceforge/silvercity/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

PYTHON_NONVERSIONED_EXECUTABLES=("/usr/bin/source2html.py")

PYTHON_MODNAME="${MY_PN}"

src_prepare() {
	distutils_src_prepare

	# Fix line endings.
	find . -type f -exec sed -e 's/\r$//' -i \{\} \; || die "sed failed"

	# Fix permissions.
	chmod -x CSS/default.css || die "chmod failed"

	# Fix shebang.
	sed -e 's:#!/usr/home/sweetapp/bin/python:#!/usr/bin/env python:' \
		-i PySilverCity/Scripts/cgi-styler-form.py || die "sed failed"
}
