# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils user

DESCRIPTION="Caching proxy for the Debian package system"
HOMEPAGE="https://sourceforge.net/projects/apt-proxy/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/xinetd"

pkg_setup () {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN}
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-sh.patch
}

src_install() {
	dosbin ${PN}

	insinto /etc/${PN}
	doins ${PN}.conf

	insinto /etc/xinetd.d
	doins "${FILESDIR}"/${PN}

	dodoc README INSTALL HISTORY
	doman ${PN}.{8,conf.5}

	# Create the log file with the proper permissions
	dodir /var/log
	touch "${D}"/var/log/${PN}.log
	fowners ${PN}:${PN} /var/log/${PN}.log

	# Create the cache directories and set the proper permissions
	dodir /var/cache/${PN}
	keepdir /var/cache/${PN}
	fowners ${PN}:${PN} /var/cache/${PN}
}

pkg_postinst() {
	einfo ""
	einfo "Don't forget to modify the /etc/${PN}/${PN}.conf"
	einfo "file to fit your needs..."
	einfo ""
	einfo "Also note that ${PN} is called from running xinetd"
	einfo "and you have to enable it first (/etc/xinetd.d/${PN})..."
	einfo ""
}

pkg_postrm() {
	einfo ""
	einfo "You have to remove the ${PN} cache by hand. It's located"
	einfo "in the \"/var/cache/${PN}\" dir..."
	einfo ""
	einfo "You can also remove the ${PN} user and group..."
	einfo ""
}
