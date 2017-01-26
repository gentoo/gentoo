# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Debug log/trace messages"
HOMEPAGE="http://liw.fi/tracing/"
SRC_URI="http://git.liw.fi/cgi-bin/cgit/cgit.cgi/python-tracing/snapshot/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	dodoc README
	use doc && dohtml -r doc/_build/html/
	if use examples; then
		docompress -x usr/share/doc/${PF}/examples/
		insinto usr/share/doc/${PF}/examples/
		doins example.py
	fi
}
