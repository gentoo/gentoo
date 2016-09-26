# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Gadu-Gadu transport for Jabber"
HOMEPAGE="https://github.com/Jajcus/jggtrans"
SRC_URI="https://github.com/Jajcus/jggtrans/releases/download/v${PV}/jggtrans-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	>=net-im/jabber-base-0.01
	>=dev-libs/glib-2.6.4:2
	net-dns/libidn
	>=net-libs/libgadu-1.9.0_rc3
	dev-libs/expat"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
"

S="${WORKDIR}/jggtrans-${PV}"

src_install() {
	emake DESTDIR="${D}" install

	keepdir /var/spool/jabber/gg
	keepdir /var/run/jabber
	keepdir /var/log/jabber
	fowners jabber:jabber /var/spool/jabber/gg
	fowners jabber:jabber /var/run/jabber
	fowners jabber:jabber /var/log/jabber

	newinitd "${FILESDIR}/jggtrans-2.2.4" jggtrans

	insinto /etc/jabber
	doins jggtrans.xml

	sed -i \
		-e 's,/var/lib/jabber/spool/gg.localhost/,/var/spool/jabber/gg/,' \
		-e 's,/var/lib/jabber/ggtrans.pid,/var/run/jabber/jggtrans.pid,' \
		-e 's,/tmp/ggtrans.log,/var/log/jabber/jggtrans.log,' \
		"${D}/etc/jabber/jggtrans.xml" || die "sed failed"

	einstalldocs
}
