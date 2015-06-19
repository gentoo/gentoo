# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/dot2tex/dot2tex-2.8.7-r1.ebuild,v 1.5 2015/04/08 18:09:45 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Graphviz to LaTeX converter"
HOMEPAGE="http://www.fauskes.net/code/dot2tex/"
SRC_URI="http://dot2tex.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="doc examples"

DEPEND=""
RDEPEND="dev-python/pyparsing[${PYTHON_USEDEP}]
	media-gfx/pydot[${PYTHON_USEDEP}]
	media-gfx/graphviz"

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then
		dohtml -r doc/*
		dodoc doc/usage.{txt,pdf}
	fi
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
