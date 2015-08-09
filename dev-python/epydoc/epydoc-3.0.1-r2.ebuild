# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='tk?'

inherit distutils-r1

DESCRIPTION="Tool for generating API documentation for Python modules from docstrings"
HOMEPAGE="http://epydoc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc latex tk"

DEPEND=""
RDEPEND="dev-python/docutils[${PYTHON_USEDEP}]
	latex? ( virtual/latex-base
			 dev-texlive/texlive-latexextra
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-docutils-0.6.patch
	"${FILESDIR}"/${PN}-python-2.6.patch
)

python_install() {
	distutils-r1_python_install

	use tk || rm "${D}$(python_get_sitedir)"/epydoc/gui.py*
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all

	doman man/epydoc.1
	if use tk; then
		doman man/epydocgui.1
	else
		rm -f "${ED}"usr/bin/epydocgui*
	fi
}
