# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/icmpdn/icmpdn-0.4.ebuild,v 1.3 2009/01/14 05:35:27 vapier Exp $

inherit eutils flag-o-matic multilib

DESCRIPTION="ICMP Domain Name utilities & NSS backend"
HOMEPAGE="http://www.dolda2000.com/~fredrik/icmp-dn/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_compile() {
	append-cppflags -D_GNU_SOURCE #241318
	econf \
		--sysconfdir=/etc \
		--libdir=/$(get_libdir) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	newinitd "${FILESDIR}"/init.d-icmpdnd icmpdnd
	newconfd "${FILESDIR}"/conf.d-icmpdnd icmpdnd
	dodoc AUTHORS ChangeLog README
	# must always run as root
	fperms 4711 /usr/bin/idnlookup
	# useless as nothing should link against this lib
	rm "${D}"/lib*/*.{la,so}
}

pkg_postinst() {
	einfo "To use the ICMP nameswitch module, add 'icmp'"
	einfo "to the 'hosts' line in your /etc/nsswitch.conf"
}
