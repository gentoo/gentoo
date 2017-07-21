# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
PYTHON_REQ_USE="ssl"

inherit python-single-r1 systemd

DESCRIPTION="Submission tools for IRC notifications"
HOMEPAGE="http://www.catb.org/esr/irker/"
SRC_URI="http://www.catb.org/esr/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="socks5"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/xmlto
	socks5? ( dev-python/PySocks[${PYTHON_USEDEP}] )"

DOCS=( NEWS README hacking.txt security.txt )
HTML_DOCS=( irkerd.html irkerhook.html )

src_prepare() {
	default

	# Rely on systemd eclass for systemd service install
	sed -i -e "/^SYSTEMDSYSTEMUNITDIR/d" Makefile \
		|| die "sed failed"

	# Prefix support
	sed -i -e "/^ExecStart=/ s:=/:=${EPREFIX}:" irkerd.service \
		|| die "sed failed"
}

src_install() {
	default

	python_doscript "${ED%/}/usr/bin/irkerd"
	# Not installed with the default Makefile
	python_doscript irk irkerhook.py

	newinitd "${FILESDIR}/irkerd.initd" irkerd
	newconfd "${FILESDIR}/irkerd.confd" irkerd

	systemd_dounit irkerd.service

	docinto examples
	dodoc filter-example.py filter-test.py
}
