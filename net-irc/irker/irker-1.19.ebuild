# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/irker/irker-1.19.ebuild,v 1.1 2013/05/06 07:17:43 patrick Exp $

EAPI=4

inherit python

DESCRIPTION="Submission tools for IRC notifications"
HOMEPAGE="http://www.catb.org/esr/irker/"
SRC_URI="http://www.catb.org/esr/${PN}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="app-text/docbook-xml-dtd:4.1.2
	app-text/xmlto"
RDEPEND="=dev-lang/python-2*
	dev-python/irc"

src_install() {
	python_convert_shebangs 2 irkerd irkerhook.py
	emake DESTDIR="${D}" install
	# the irkerhook.py is not installed with the default makefile
	dobin irkerhook.py
	newinitd "${FILESDIR}/irker.init" irkerd
	newconfd "${FILESDIR}/irker.conf.d" irkerd
}
