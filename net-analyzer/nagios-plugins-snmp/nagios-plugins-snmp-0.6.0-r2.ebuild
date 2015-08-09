# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools user

DESCRIPTION="Additional Nagios plugins for monitoring SNMP capable devices"
HOMEPAGE="http://nagios.manubulon.com"
SRC_URI="http://nagios.manubulon.com/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 ~sparc x86"
IUSE=""

DEPEND="net-analyzer/net-snmp"
RDEPEND="${DEPEND}"

S=${WORKDIR}/nagios-plugins-snmp

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_prepare() {
	sed -i -e '/^CFLAGS=""/d' configure.in
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir=/etc/nagios \
		--libexec=/usr/$(get_libdir)/nagios/plugins
}

DOCS=( README NEWS AUTHORS )

src_install() {
	default

	fowners root:nagios /usr/$(get_libdir)/nagios/plugins
	fperms o-rwx /usr/$(get_libdir)/nagios/plugins
}
