# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="MonMotha IPTables-based firewall script"
HOMEPAGE="http://monmotha.mplug.org/firewall/"
LICENSE="GPL-2"

KEYWORDS="x86 ~amd64"
IUSE=""
SLOT="0"
RDEPEND=">=net-firewall/iptables-1.2.5"

MY_PVP=(${PV//[-\._]/ })

S=${WORKDIR}

SRC_URI="http://monmotha.mplug.org/~monmotha/firewall/firewall/${MY_PVP[0]}.${MY_PVP[1]}/rc.firewall-${PV}"

src_unpack() {
	cp "${DISTDIR}"/${A} "${S}"/
}

src_install() {
	newinitd "${FILESDIR}/monmotha.rc6" monmotha
	exeinto /etc/monmotha
	newexe "${S}/rc.firewall-${PV}" monmotha
}

pkg_postinst () {
	einfo "Don't forget to add the 'monmotha' startup script  to your default"
	einfo "runlevel by typing the following command:"
	einfo ""
	einfo "	 rc-update add monmotha default"
	einfo ""
	einfo "You need to edit /etc/monmotha/monmotha before using"
	einfo "it.  Enter the right vars in the file, start the script"
	einfo "by typing: '/etc/init.d/monmotha start' and it should work."
	einfo ""
	einfo "Don't forget to change the path to iptables!!!"
	einfo ""
	einfo "Note: If You are stopping the firewall, all iptables rulesets"
	einfo "will be flushed!!!"
	einfo ""
}
