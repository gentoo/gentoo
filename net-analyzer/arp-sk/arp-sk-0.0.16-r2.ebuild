# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/arp-sk/arp-sk-0.0.16-r2.ebuild,v 1.8 2014/07/10 19:10:27 jer Exp $

EAPI=5
inherit autotools eutils multilib

DESCRIPTION="A swiss knife tool for ARP"
HOMEPAGE="http://sid.rstack.org/arp-sk/"
SRC_URI="http://sid.rstack.org/arp-sk/files/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND=">=net-libs/libnet-1.1"
RDEPEND="${DEPEND}"

DOCS=( ARP AUTHORS CONTRIB ChangeLog README TODO )

src_prepare() {
	epatch "${FILESDIR}"/${P}-libnet1_2.patch
	sed -i configure.in -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	rm missing || die
	epatch_user

	eautoreconf
}

src_install() {
	default

	# We don't need libcompat as it has a potential to clash with other packages.
	rm -fr "${D}"/usr/$(get_libdir)
}
