# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )
PYTHON_REQ_USE="ssl"

inherit python-single-r1 systemd eutils

DESCRIPTION="Submission tools for IRC notifications"
HOMEPAGE="http://www.catb.org/esr/irker/"
SRC_URI="http://www.catb.org/esr/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/xmlto"

src_prepare() {
	# https://gitorious.org/irker/irker/merge_requests/25
	epatch "${FILESDIR}/2.7-Register-author_name-as-author-instead-of-email-user.patch"

	epatch "${FILESDIR}/2.7-irkerhook-Remove-file-listing.patch"

	# Rely on systemd eclass for systemd service install
	sed -i -e "/^SYSTEMDSYSTEMUNITDIR/d" Makefile \
		|| die "sed failed"

	# Prefix support
	sed -i -e "/^ExecStart=/ s:=/:=${EROOT}:" irkerd.service \
		|| die "sed failed"
}

src_install() {
	emake DESTDIR="${ED}" install

	python_doscript "${ED}/usr/bin/irkerd"
	# Not installed with the default Makefile
	python_doscript irk irkerhook.py

	newinitd "${FILESDIR}/irkerd.initd" irkerd
	newconfd "${FILESDIR}/irkerd.confd" irkerd

	systemd_dounit irkerd.service

	dodoc NEWS README hacking.txt security.txt
	dohtml irkerd.html irkerhook.html

	docinto examples
	dodoc filter-example.py filter-test.py
}
