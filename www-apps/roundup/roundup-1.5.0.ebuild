# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Simple-to-use and -install issue-tracking system with command-line, web, and e-mail interfaces"
HOMEPAGE="http://roundup.sourceforge.net http://pypi.python.org/pypi/roundup"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT ZPL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND=">=sys-libs/db-3.2.9"
RDEPEND="${DEPEND}"

DOCS="CHANGES.txt doc/*.txt"

python_install_all() {
	distutils-r1_python_install_all
	rm -r "${ED}"/usr/share/doc/${PN} || die
	dohtml -r doc/*
}

pkg_postinst() {
	ewarn "As a non privileged user! (not root)"
	ewarn "Run 'roundup-admin install' to set up a roundup instance"
	ewarn "Then edit your config.ini file in the tracker home you setup"
	ewarn "Run 'roundup-admin initialise' to setup the admin pass"
	ewarn "run /usr/bin/roundup start port host \"your tracker name\" [your tracker home], and all should work!"
	ewarn "run /usr/bin/roundup stop [your tracker home] to stop the server"
	ewarn "log is in [tracker home]/roundup.log"
	ewarn "pid file is in [tracker home]/roundup.pid"
	ewarn
	ewarn "See upgrading.txt for upgrading instructions."
}
