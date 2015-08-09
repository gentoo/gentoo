# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="ssl"

inherit python-single-r1 eutils

DESCRIPTION="Submission tools for IRC notifications"
HOMEPAGE="http://www.catb.org/esr/irker/"
SRC_URI="http://www.catb.org/esr/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-text/docbook-xml-dtd:4.1.2
	app-text/xmlto"

src_prepare() {
	# https://gitorious.org/irker/irker/merge_requests/25
	epatch "${FILESDIR}/2.7-Register-author_name-as-author-instead-of-email-user.patch"

	epatch "${FILESDIR}/2.7-irkerhook-Remove-file-listing.patch"

	# Prefix support
	sed -i -e "/^ExecStart=/ s:=/:=${EROOT}:" irkerd.service
}

src_install() {
	emake DESTDIR="${ED}" install

	python_doscript "${ED}/usr/bin/irkerd"
	# Not installed with the default Makefile
	python_doscript irk irkerhook.py

	newinitd "${FILESDIR}/irkerd.initd" irkerd
	newconfd "${FILESDIR}/irkerd.confd" irkerd

	dodoc NEWS README hacking.txt security.txt
	dohtml irkerd.html irkerhook.html

	docinto examples
	dodoc filter-example.py filter-test.py
}
