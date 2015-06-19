# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/tracing/tracing-0.7-r1.ebuild,v 1.2 2015/04/08 08:05:07 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
MY_P="python-${P}"

inherit distutils-r1

DESCRIPTION="Debug log/trace messages"
HOMEPAGE="http://liw.fi/tracing/"
SRC_URI="http://code.liw.fi/debian/pool/main/p/python-${PN}/python-${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

S="${WORKDIR}/${MY_P}"

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
