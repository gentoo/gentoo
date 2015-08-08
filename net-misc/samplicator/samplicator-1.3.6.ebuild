# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils user

DESCRIPTION="UDP packets forwarder and duplicator"
HOMEPAGE="http://${PN}.googlecode.com/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

pkg_setup() {
	# Add samplicator group and user to system
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /etc/${PN} ${PN}
}

src_install() {
	# Install and copy documentation
	default

	# Install Gentoo init script and its config
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}

	# Install manual page
	doman "${FILESDIR}"/${PN}.8
}

pkg_postinst() {
	ewarn ""
	ewarn "Don't specify the receiver on the command line, because it will get all packets."
	ewarn "Instead of this, specify it in a config file; defined in such way it will only get packets with a matching source."
	ewarn ""

	einfo "For every receiver type create a file in directory /etc/${PN} (see example below)"
	einfo "and specify the path to it in variable CONFIG of the corresponding initscript config file in /etc/conf.d/"
	einfo ""
	einfo "Receiver config examples: "
	einfo ""
	einfo "    /etc/${PN}/netflow:"
	einfo "    10.0.0.0/255.0.0.0:1.1.1.1/9996 2.2.2.2/9996 3.3.3.3/9996"
	einfo ""
	einfo "    /etc/${PN}/syslog:"
	einfo "    10.0.0.0/255.255.0.0:2.2.2.2/514 3.3.3.3/514"
	einfo ""
	einfo "    /etc/${PN}/snmp:"
	einfo "    10.0.0.0/255.255.255.255:3.3.3.3/162"
}
